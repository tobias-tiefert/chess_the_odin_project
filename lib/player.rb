# frozen_string_literal: true

require_relative 'translate'

# class that represents the players of the chess game
class Player
  attr_reader :name, :color, :king

  include TRANSLATE

  def initialize(name = 'Player 1', color = 'white', board = nil)
    @name = name
    @color = color
    @board = board
  end

  def decide
    positions_before = @board.snapshot
    message_before_decide
    loop do
      input = gets.chomp.downcase
      make_move(input, @board) if valid?(input) && still_in_check?(input) == false
      break if @board.snapshot != positions_before

      message_no_valid_decision
    end
  end

  def check?
    @board.under_attack?(@board.king(@color).position, @color)
  end

  def checkmate?
    check? && no_solution?
  end

  def stalemate?
    check? == false && no_solution?
  end

  def no_solution?
    @board.all(@color).each do |piece|
      piece.moves.each do |move|
        input = "#{piece.translate_back(piece.position)}->#{piece.translate_back(move)}"
        return false unless still_in_check?(input)
      end
    end
    true
  end

  private

  def message_before_decide
    puts "\e[91m#{@name} you are in check\e[0m" if check?
    puts "#{@name} make your move\n"
  end

  def message_no_valid_decision
    puts "You can't make this move. You would still be in check" if check?
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
    input = user_input.split('->')
    piece = board.at(translate(input[0].strip))
    board == @board ? move_error_handling(piece, input) : piece.move_without_puts(translate(input[1].strip))
  end

  def move_error_handling(piece, input)
    if piece.nil?
      puts "There is nothing on #{input[0].strip}"
    elsif piece.color == @color
      piece.move(translate(input[1].strip))
    else
      puts "\n#{@name} don't try to move a #{piece.color} piece. Your color is #{@color}"
    end
  end
end
