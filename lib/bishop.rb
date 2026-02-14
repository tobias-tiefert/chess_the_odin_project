# frozen_string_literal: true

require_relative 'long_distance_piece'

# class that represents the bishop piece in the chess game
class Bishop < LongDistancePiece
  WHITE_TOKEN = '♗'
  BLACK_TOKEN = '♝'

  def initialize(color = 'white', field_color = 'white')
    super(color)
    @directions = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
    @token = create_token(color, WHITE_TOKEN, BLACK_TOKEN)
    @field_color = field_color
  end
end
