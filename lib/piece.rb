# frozen_string_literal: true

# super class for all the pieces in the chess game
class Piece
  attr_reader :color, :token
  attr_writer :board

  WHITE_TOKEN = '♙'
  BLACK_TOKEN = '♟'
  def initialize(color = 'white')
    @color = color
    @position = nil
    @board = nil
    @token = create_token(color, WHITE_TOKEN, BLACK_TOKEN)
  end

  def create_token(color, token1, token2)
    color == 'white' ? token1 : token2
  end

  def on_the_board?(x_position, y_position)
    x_position.between?(0, 7) && y_position.between?(0, 7)
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

  def legal_move?(position)
    field = @board.element(position)
    on_the_board?(position[0], position[1]) && (field.nil? || field.color != @color)
  end

  def new_position(position, position_change)
    [position[0] + position_change[0], position[1] + position_change[1]]
  end
end
