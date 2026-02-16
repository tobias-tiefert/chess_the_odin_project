# frozen_string_literal: true

require_relative 'lib/board'
require_relative 'lib/rook'
require_relative 'lib/long_distance_piece'
require_relative 'lib/piece'
require_relative 'lib/queen'
require_relative 'lib/bishop'
require_relative 'lib/pawn'
require_relative 'lib/knight'
require_relative 'lib/game'

game = Game.new
game.start
board = Board.new
knight = Knight.new('white')
board.put_on_board(knight, [4, 6])
board.draw_board
puts board.position_snapshot
