# frozen_string_literal: true

require_relative 'lib/board'
require_relative 'lib/piece'
require_relative 'lib/rook'

board = Board.new
rook = Rook.new('white')
board.put_on_board(rook, [3, 4])
board.draw_board
