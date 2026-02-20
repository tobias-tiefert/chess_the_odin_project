# frozen_string_literal: true

require_relative 'piece'
require_relative 'queen'
require_relative 'bishop'
require_relative 'rook'
require_relative 'knight'
require_relative 'dummy_pawn'

# class that represents the pawn piece in the chess game
class Pawn < Piece
  WHITE_TOKEN = '♙'
  BLACK_TOKEN = '♟'
  WHITE_DIRECTIONS = {
    move: [0, -1],
    strikes: [[-1, -1], [1, -1]],
    long_move: [0, -2]
  }
  BLACK_DIRECTIONS = {
    move: [0, 1],
    strikes: [[-1, 1], [1, 1]],
    long_move: [0, 2]
  }
  PROMOTE_MESSAGE = <<~HEREDOC
    Your pawn get's promoted
    Tpye [Q] to promote to a queen
    Tpye [R] to promote to a rook
    Tpye [B] to promote to a bishop
    Tpye [K] to promote to a knight
  HEREDOC

  def initialize(color = 'white', board = nil)
    super(color, board)
    @name = 'Pawn'
    @directions = directions(@color)
    @token = create_token(color, WHITE_TOKEN, BLACK_TOKEN)
    @promote_line = promote_line(color)
  end

  def directions(color)
    color == 'white' ? WHITE_DIRECTIONS : BLACK_DIRECTIONS
  end

  def moves(position = @position, directions = @directions)
    output = []
    output << pawn_move(position, directions[:move])
    output << pawn_move(position, directions[:long_move]) unless output[0].nil? || @moved == true
    strike_moves = strikes(position, directions[:strikes])
    strike_moves&.each { |position| output << position }
    output.compact
  end

  def strikes(position, directions)
    output = []
    directions.each do |strike|
      new_position = new_position(position, strike)

      output << new_position if legal_strike?(new_position)
    end
    output unless output.empty?
  end

  def pawn_move(position, direction)
    move_position = new_position(position, direction)
    move_position if legal_move?(move_position)
  end

  def move(target)
    moves.include?(target) ? perform_pawn_move(target) : no_valid_move_message(target)
    promote if @position[1] == @promote_line
  end

  def test_move(target)
    moves.include?(target) ? perform_pawn_test_move(target) : no_valid_move_message(target)
  end

  def perform_pawn_move(target)
    target_field = @board.at(target)
    if target_field.is_a?(DummyPawn)
      en_passant(target, target_field)
    else
      @board.remove_dummy
      place_dummy(target) if @moved == false && long_move?(target)
      perform_move(target)
    end
  end

  def perform_pawn_test_move(target)
    target_field = @board.at(target)
    if target_field.is_a?(DummyPawn)
      test_en_passant(target, target_field)
    else
      @board.remove_dummy
      place_dummy(target) if @moved == false && long_move?(target)
      perform_test_move(target)
    end
  end

  def en_passant(target, dummy_pawn)
    @board.positions[dummy_pawn.pawn_position[1]][dummy_pawn.pawn_position[0]] = nil
    update_board(target)
    strike_message(dummy_pawn)
    @moved = true
  end

  def test_en_passant(target, dummy_pawn)
    @board.positions[dummy_pawn.pawn_position[1]][dummy_pawn.pawn_position[0]] = nil
    update_board(target)
    @moved = true
  end

  def promote
    @board.draw_board
    puts PROMOTE_MESSAGE
    @board.put_on_board(new_piece(user_input), @position)
  end

  private

  def promote_line(color)
    color == 'white' ? 0 : 7
  end

  def opponent_field?(field_element)
    !field_element.nil? && field_element.color == @opponent_color
  end

  def place_dummy(target)
    dummy_position = @color == 'white' ? [target[0], target[1] + 1] : [target[0], target[1] - 1]
    dummy = DummyPawn.new(target, @color)
    @board.put_on_board(dummy, dummy_position)
  end

  def long_move?(target)
    long_move_line = @color == 'white' ? 4 : 3
    target[1] == long_move_line
  end

  def legal_move?(position)
    return false unless on_the_board?(position)

    field = @board.at(position)
    field_color = field.nil? ? 'empty' : field.color
    on_the_board?(position) && free_field?(field_color)
  end

  def legal_strike?(position)
    field = @board.at(position)
    on_the_board?(position) && opponent_field?(field)
  end

  def new_piece(user_input)
    case user_input
    when 'q'
      Queen.new(@color)
    when 'r'
      Rook.new(@color)
    when 'b'
      Bishop.new(@color)
    when 'k'
      Knight.new(@color)
    end
  end

  def user_input
    loop do
      user_input = gets.chomp.downcase
      return user_input if user_input.match?(/[qrbk]/) && user_input.length == 1

      puts 'Please choose a valid option'
    end
  end
end
