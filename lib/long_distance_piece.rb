# frozen_string_literal: true

require_relative 'piece'

# super class for the queen, bishop and rook pieces in the chess game
class LongDistancePiece < Piece
  WHITE_TOKEN = '♕'
  BLACK_TOKEN = '♛'

  def initialize(color = 'white')
    super(color)
  end

  def moves(position = @position, directions = @directions)
    output = []
    directions.each do |direction|
      new_position = new_position(position, direction)
      while legal_move?(new_position)
        output << new_position
        break unless @board.element(position).nil?

        new_position = new_position(new_position, direction)
      end
    end
    output.sort
  end
end
