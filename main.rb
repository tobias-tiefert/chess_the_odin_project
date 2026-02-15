# frozen_string_literal: true

require_relative 'lib/board'
require_relative 'lib/rook'
require_relative 'lib/long_distance_piece'
require_relative 'lib/piece'
require_relative 'lib/queen'
require_relative 'lib/bishop'
require_relative 'lib/pawn'

board = Board.new

queen = Queen.new('white')
bishop = Bishop.new('white')
board.put_on_board(bishop, [3, 4])
board.put_on_board(queen, [0, 4])
board.draw_board
# print queen.moves
queen.move([7, 4])
# board.draw_board
# bishop.move([3, 0])
# board.positions.each_with_index { |position, index| puts "#{position} , index: #{index}" }

# rint bishop.moves
