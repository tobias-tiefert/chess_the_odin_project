# frozen_string_literal: true

require_relative 'long_distance_piece'

# class that represents the queen piece in the chess game
class Queen < LongDistancePiece
  WHITE_TOKEN = '♕'
  BLACK_TOKEN = '♛'

  def initialize(color = 'white', board = nil)
    super(color, board)
    @name = 'Queen'
    @directions = [[0, 1], [1, 0], [0, -1], [-1, 0],
                   [1, 1], [-1, 1], [-1, -1], [1, -1]]
    @token = create_token(color, WHITE_TOKEN, BLACK_TOKEN)
  end
end
