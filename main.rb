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
board = Board.new
white_king = King.new('white')
black_king = King.new('black')
white_rook = Rook.new('white')
black_rook = Rook.new('black')
white_queen = Queen.new('white')
black_queen = Queen.new('black')

board.put_on_board(white_king, [7, 7])
board.put_on_board(black_king, [4, 0])
board.put_on_board(black_queen, [6, 0])
board.put_on_board(black_rook, [0, 6])
board.put_on_board(white_rook, [2, 7])

game.start_test(board)
