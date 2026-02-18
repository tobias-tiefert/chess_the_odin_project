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
# game.start
board = Board.new
black_king = King.new('black')
board.put_on_board(King.new('white'), [4, 7])
# board.put_on_board(Knight.new('white'), [1, 7])
board.put_on_board(black_king, [4, 0])
# board.put_on_board(Queen.new('black'), [3, 1])
board.put_on_board(Rook.new('black'), [0, 0])
board.put_on_board(Rook.new('white'), [0, 7])
board.put_on_board(Rook.new('black'), [7, 0])
board.put_on_board(Rook.new('white'), [7, 7])

# print black_king.moves
game.start_test(board)
