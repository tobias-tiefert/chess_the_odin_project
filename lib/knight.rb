# frozen_string_literal: true

require_relative 'piece'

# class that represents the knight piece in the chess game
class Knight < Piece
  WHITE_TOKEN = '♘'
  BLACK_TOKEN = '♞'

  def initialize(color = 'white', board = nil)
    super(color, board)
    @name = 'Knight'
    @directions = [[2, 1], [2, -1], [1, 2], [1, -2],
                   [-2, 1], [-2, -1], [-1, 2], [-1, -2]]
    @token = create_token(color, WHITE_TOKEN, BLACK_TOKEN)
  end
end
