# frozen_string_literal: true

require_relative 'piece'

# class that represents the rook piece in the chess game
class Rook < Piece
  WHITE_TOKEN = '♖'
  BLACK_TOKEN = '♜'

  def initialize(color = 'white')
    super(color)
    @directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
    @token = create_token(color, WHITE_TOKEN, BLACK_TOKEN)
    @moved = false
  end
end
