# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# class that represents the chess game
class Game
  def initialize
    @board = Board.new
    @players = [
      Player.new('Player 1', 'white', @board),
      Player.new('Player 2', 'black', @board)
    ]
    @current_player = @players[0]
    @winner = nil
  end

  def game_over?
    @winner.nil? ? false : true
  end

  def switch_players
    @current_player = @current_player == @players[0] ? @players[1] : @players[0]
  end

  def result
    @board.draw_board
    message = @winner == false ? "It's a draw" : "#{@winner.name} wins the game"
    puts message
  end
end
