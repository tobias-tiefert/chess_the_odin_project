# frozen_string_literal: true

require_relative 'piece'

# super class for the queen, bishop and rook pieces in the chess game
class LongDistancePiece < Piece
  WHITE_TOKEN = '♕'
  BLACK_TOKEN = '♛'

  def initialize(color = 'white', board = nil)
    super(color, board)
  end

  def moves(position = @position)
    output = []
    @directions.each do |direction|
      first_step = [position[0] + direction[0], position[1] + direction[1]]
      output += moves_recursive(first_step, direction)
    end
    output
  end

  private

  def moves_recursive(position, direction, output = [])
    field_element_color = @board.element(position).nil? ? 'empty' : @board.element(position).color
    output << position if on_the_board?(position) && field_element_color != @color
    new_position = [position[0] + direction[0], position[1] + direction[1]]
    moves_recursive(new_position, direction, output) if on_the_board?(new_position) && field_element_color == 'empty'
    output
  end
end
