# frozen_string_literal: true

require_relative 'piece'

# class that represents the pawn piece in the chess game
class Pawn < Piece
  WHITE_TOKEN = '♙'
  BLACK_TOKEN = '♟'
  WHITE_DIRECTIONS = {
    move: [0, -1],
    strikes: [[-1, -1], [1, -1]],
    long_move: [0, -2]
  }
  BLACK_DIRECTIONS = {
    move: [0, 1],
    strikes: [[-1, 1], [1, 1]],
    long_move: [0, 2]
  }

  def initialize(color = 'white', board = nil)
    super(color, board)
    @name = 'Pawn'
    @directions = get_directions(@color)
    @token = create_token(color, WHITE_TOKEN, BLACK_TOKEN)
    @moved = false
  end

  def get_directions(color)
    color == 'white' ? WHITE_DIRECTIONS : BLACK_DIRECTIONS
  end

  def moves(position = @position, directions = @directions)
    output = []
    output << pawn_move(position, directions[:move])
    output << pawn_move(position, directions[:long_move]) unless output[0].nil? || @moved == true
    strike_moves = strikes(position, directions[:strikes])
    strike_moves&.each { |position| output << position }
    output.compact
  end

  def strikes(position, directions)
    output = []
    directions.each do |strike|
      new_position = new_position(position, strike)

      output << new_position if legal_strike?(new_position)
    end
    output unless output.empty?
  end

  def pawn_move(position, direction)
    move_position = new_position(position, direction)
    move_position if legal_move?(move_position)
  end

  def legal_move?(position)
    field = @board.at(position)
    on_the_board?(position) && field.nil?
  end

  def legal_strike?(position)
    field = @board.at(position)
    on_the_board?(position) && field.nil? == false && field.color != @color
  end
end
