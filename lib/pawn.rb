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
    @directions = get_directions(@color)
    @token = create_token(color, WHITE_TOKEN, BLACK_TOKEN)
    @promote_line = get_promote_line(color)
    @dummy_opponent_color = dummy_opponent_color
  end

  def get_directions(color)
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
    super
    promote if @position[1] == @promote_line
  end

  def get_promote_line(color)
    color == 'white' ? 0 : 7
  end

  def promote
    @board.draw_board
    puts PROMOTE_MESSAGE
    @board.put_on_board(new_piece(user_input), @position)
  end

  private

  def legal_move?(position)
    field = @board.at(position)
    field_color = field.nil? ? 'empty' : field.color
    on_the_board?(position) && free_field?(field_color)
  end

  def legal_strike?(position)
    field = @board.at(position)
    field_color = field.nil? ? 'empty' : field.color
    on_the_board?(position) && opponent_field?(field_color)
  end

  def dummy_opponent_color
    @color == 'white' ? 'dummy_black' : 'dummy_white'
  end

  def opponent_field?(field_element_color)
    [@opponent_color, @dummy_opponent_color].include?(field_element_color)
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
