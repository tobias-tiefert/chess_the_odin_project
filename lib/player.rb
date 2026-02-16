# frozen_string_literal: true

# class that represents the players of the chess game
class Player
  attr_reader :name, :color

  def initialize(name, color, board)
    @name = name
    @color = color
    @board = board
  end
end
