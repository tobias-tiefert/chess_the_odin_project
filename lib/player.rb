# frozen_string_literal: true

require_relative 'translate'

# class that represents the players of the chess game
class Player
  attr_reader :name, :color, :king
  attr_writer :board # only for test purpose

  include TRANSLATE

  def initialize(name = 'Player 1', color = 'white', board = nil)
    @name = name
    @color = color
    @board = board
  end

  def decide
    positions_before = @board.snapshot
    castled_before = {
      white: @board.king('white').castled,
      black: @board.king('black').castled
    }
    message_before_decide
    decision_loop(positions_before, castled_before)
  end

  def check?
    @board.under_attack?(@board.king(@color).position, @color)
  end

  def checkmate?
    check? && no_solution?
  end

  def stalemate?
    !check? && no_solution?
  end

  def no_solution?
    @board.all(@color).all? do |piece|
      piece.moves.all? do |move|
        still_in_check?("#{piece.translate_back(piece.position)}->#{piece.translate_back(move)}")
      end
    end
  end

  private

  def message_before_decide
    puts ' '
    puts "\e[91m#{@name} you are in check\e[0m" if check?
    puts "#{@name} make your move\n"
  end

  def message_no_valid_decision(input)
    puts ' '

    if valid?(input) && input_piece(input) && input_piece(input).color == @color
      puts "You can't make this move. You would still be in check" if still_in_check?(input) && check?
      puts "You can't make this move. You would be in check" if still_in_check?(input) && !check?
    end

    puts 'Please choose again'
  end

  def still_in_check?(input)
    dummy_board = @board.copy
    make_move(input, dummy_board)
    dummy_board.under_attack?(dummy_board.king(@color).position, @color)
  end

  def valid?(input)
    input.match?(/[a-h][1-8]\s?->\s?[a-h][1-8]/)
  end

  def make_move(user_input, board = @board)
    piece = input_piece(user_input, board)
    target = translate(user_input.split('->')[1].strip)
    return if piece.nil?

    board == @board ? piece.move(target) : piece.move(target, 'test')
  end

  def wrong_input_message(user_input)
    input = user_input.split('->')
    piece = input_piece(user_input)
    if piece.nil?
      puts "\nThere is nothing on #{input[0].strip}"
    elsif piece.color != @color
      puts "\n#{@name} don't try to move a #{piece.color} piece."
    end
  end

  def wrong_input?(input)
    piece = input_piece(input)
    piece.nil? || piece.color != @color
  end

  def input_piece(user_input, board = @board)
    return false if user_input.nil?

    input = user_input.split('->')
    board.at(translate(input[0].strip))
  end

  def decision_loop(positions_before, castled_before)
    loop do
      input = gets.chomp.downcase
      if input.include?('resign') || input.include?('draw') || input.include?('save') || input.include?('load')
        return input
      end

      process_input(input)
      move = {
        positions_before: positions_before,
        castled_before: castled_before,
        input: input
      }
      return move if @board.snapshot != positions_before

      message_no_valid_decision(input)
    end
  end

  def process_input(input)
    if wrong_input?(input)
      wrong_input_message(input)
    elsif !wrong_input?(input) && valid?(input) && !still_in_check?(input)
      make_move(input, @board)
    end
  end
end
