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
    puts "#{@name} make your move"
    loop do
      make_move(gets.chomp.downcase)
      break if @board.snapshot != positions_before

      puts 'Please choose again'
    end
  end

  def make_move(player_input)
    input = player_input.split('->')
    piece = @board.at(translate(input[0].strip))
    piece.move(translate(input[1].strip)) if piece.color == @color
  end
end
