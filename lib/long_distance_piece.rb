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
      output += moves_recursive(first_step, direction) if on_the_board?(first_step)
    end
    output
  end

  private

  def moves_recursive(position, direction, output = [])
    field_element_color = @board.at(position).nil? ? 'empty' : @board.at(position).color
    if on_the_board?(position) && free_field?(field_element_color) || opponent_field?(field_element_color)
      output << position
    end
    new_position = [position[0] + direction[0], position[1] + direction[1]]
    moves_recursive(new_position, direction, output) if on_the_board?(new_position) && free_field?(field_element_color)
    output
  end
end
