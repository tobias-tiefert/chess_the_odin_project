# frozen_string_literal: true

require_relative 'piece'

# class that represents the king piece in the chess game
class King < Piece
  WHITE_TOKEN = '♔'
  BLACK_TOKEN = '♚'

  def initialize(color = 'white')
    super(color)
    @name = 'King'
    @directions = [[0, 1], [1, 0], [0, -1], [-1, 0],
                   [1, 1], [-1, 1], [-1, -1], [1, -1]]
    @token = create_token(color, WHITE_TOKEN, BLACK_TOKEN)
    @casteling_moves = casteling_moves
  end

  def casteling_moves
    @color == 'white' ? [[2, 7], [6, 7]] : [[2, 0], [6, 0]]
  end

  def moves(position = @position, directions = @directions)
    output = super
    output += @casteling_moves if @moved == false
    output.sort
  end

  def move(target)
    if @casteling_moves.include?(target) && @moved == false
      casteling(target)
    else
      super
    end
  end

  def test_move(target)
    super unless @casteling_moves.include?(target) && @moved == false
  end

  private

  def casteling(target)
    if target == @casteling_moves[0] && casteling_conditions('left')
      perform_casteling('left')
    elsif target == @casteling_moves[1] && casteling_conditions('right')
      perform_casteling('right')
    end
  end

  def perform_casteling(side)
    line = @position[1]
    corner = side == 'left' ? 0 : 7
    target = side == 'left' ? @position[0] - 2 : @position[0] + 2
    rook_target = side == 'left' ? target + 1 : target - 1
    rook = @board.at([corner, line])
    perform_move([target, line])
    rook.perform_move([rook_target, line])
  end

  def casteling_conditions(side)
    line = @position[1]
    corner = side == 'left' ? 0 : 7
    return true if no_attack?(traversing(side)) && free_way?(between(side)) && rook_moved?([corner, line]) == false

    error_messages(no_attack?(traversing(side)), free_way?(between(side)), rook_moved?([corner, line]), side)
    false
  end

  def traversing(side)
    line = @position[1]
    direction = side == 'left' ? -1 : 1
    [@position, [@position[0] + 1 * direction, line], [@position[0] + 2 * direction, line]]
  end

  def between(side)
    line = @position[1]
    side == 'right' ? traversing(side) - [@position] : traversing(side) - [@position] + [[1, line]]
  end

  def no_attack?(fields)
    fields.all? { |field| @board.under_attack?(field, @color) == false }
  end

  def free_way?(fields)
    fields.all? { |field| @board.at(field).nil? }
  end

  def rook_moved?(position)
    @board.at(position).moved if @board.at(position).nil? == false && @board.at(position).is_a?(Rook)
  end

  def error_messages(no_attack, free_way, rook_moved, side)
    puts "\nYou can't castle because:"
    puts '- the fields that the king crosses are under attack' unless no_attack
    puts '- the fields between the king and the rook are not free' unless free_way
    puts "- the #{side} rook has been moved before" if rook_moved
  end
end
