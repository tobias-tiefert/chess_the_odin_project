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
# board.set_up
# board.draw_board

queen = Queen.new
knight = Knight.new('white')
board.put_on_board(knight, [4, 6])
board.put_on_board(queen, [7, 7])
puts 'old board'
board.draw_board

puts 'new board'

rook = Rook.new('black')
board.put_on_board(rook, [0, 0])
puts 'new'
puts 'old'
board.draw_board
print rook.moves

puts board.under_attack?([7, 7], 'white')

puts board.snapshot.delete('-')
