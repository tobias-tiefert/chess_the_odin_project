# frozen_string_literal: true

require_relative 'piece'

# class that represents the king piece in the chess game
class King < Piece
  WHITE_TOKEN = '♔'
  BLACK_TOKEN = '♚'

  def initialize(color = 'white')
    super(color)
    @directions = [[0, 1], [1, 0], [0, -1], [-1, 0],
                   [1, 1], [-1, 1], [-1, -1], [1, -1]]
    @token = create_token(color, WHITE_TOKEN, BLACK_TOKEN)
  end
end
