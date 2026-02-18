# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# class that represents the chess game
class Game
  attr_reader :players

  def initialize
    @board = Board.new(self)
    @players = [
      Player.new('White', 'white', @board),
      Player.new('Black', 'black', @board)
    ]
    @current_player = @players[0]
    @winner = nil
    @draw_message = "It's a draw"
  end

  def start
    @board.set_up
    play until game_over?
    result
  end

  def play
    @board.draw_board
    @current_player.decide
    check_winner
    switch_players
  end

  def game_over?
    @winner.nil? ? false : true
  end

  def switch_players
    @current_player = @current_player == @players[0] ? @players[1] : @players[0]
  end

  private

  def result
    @board.draw_board
    message = @winner == false ? "\e[96m#{@draw_message}\e[0m" : "\e[96mCheckmate - #{@winner.name} wins the game!\e[0m"
    puts message
  end
end

def check_winner
  other_player = @current_player == @players[0] ? @players[1] : @players[0]
  @winner = @current_player if other_player.checkmate?
  return unless @current_player.stalemate?

  @winner = false
  @draw_message = "It's a draw - stalemate"
end
