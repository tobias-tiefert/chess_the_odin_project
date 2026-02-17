# frozen_string_literal: true

require_relative 'translate'

# class that represents the players of the chess game
class Player
  attr_reader :name, :color

  include TRANSLATE

  def initialize(name = 'Player 1', color = 'white', board = nil)
    @name = name
    @color = color
    @board = board
  end

  def decide
    positions_before = @board.snapshot
    puts "#{@name} make your move\n"
    loop do
      input = gets.chomp.downcase
      make_move(input) if valid?(input)
      break if @board.snapshot != positions_before

      puts 'Please choose again'
    end
  end

  private

  def valid?(input)
    input.match?(/[a-h][1-8]\s?->\s?[a-h][1-8]/)
  end

  def make_move(player_input)
    input = player_input.split('->')
    piece = @board.at(translate(input[0].strip))
    if piece.color == @color
      piece.move(translate(input[1].strip))
    else
      puts "\n#{@name} don't try to move a #{piece.color} piece. Your color is #{@color}"
    end
  end
end
