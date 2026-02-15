# frozen_string_literal: true

require_relative 'long_distance_piece'

# class that represents the rook piece in the chess game
class Rook < LongDistancePiece
  WHITE_TOKEN = '♖'
  BLACK_TOKEN = '♜'

  def initialize(color = 'white', board = nil)
    super(color, board)
    @name = 'Rook'
    @directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
    @token = create_token(color, WHITE_TOKEN, BLACK_TOKEN)
    @moved = false
  end
end
