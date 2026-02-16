# frozen_string_literal: true

require_relative 'lib/board'
require_relative 'lib/rook'
require_relative 'lib/long_distance_piece'
require_relative 'lib/piece'
require_relative 'lib/queen'
require_relative 'lib/bishop'
require_relative 'lib/pawn'
require_relative 'lib/knight'

board = Board.new

board.set_up
board.draw_board
