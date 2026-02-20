# frozen_string_literal: true

require_relative 'piece'

# class that enables the pawn to strike en passant
class DummyPawn
  attr_writer :board
  attr_accessor :pawn_position, :color, :token, :name, :position

  WHITE_TOKEN = ' '
  BLACK_TOKEN = ' '
  def initialize(pawn_position, color = 'white', board = nil)
    @color = color
    @board = board
    @position = nil
    @name = 'Pawn'
    @token = create_token(color, WHITE_TOKEN, BLACK_TOKEN)
    @pawn_position = pawn_position
  end

  def create_token(color, token1, token2)
    color == 'white' ? token1 : token2
  end
end
