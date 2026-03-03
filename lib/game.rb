# frozen_string_literal: true

require 'yaml'
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

  def start_test(board)
    @board = board
    players[0].board = board
    players[1].board = board

    play until game_over?
    result
  end

  def play
    @board.draw_board
    result = @current_player.decide
    process_result(result)
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
    message = @winner == false ? "\n\e[96m#{@draw_message}\e[0m" : "\n\e[96m#{@win_message}\e[0m"
    puts message
  end

  def process_result(result)
    other_player = @current_player == @players[0] ? @players[1] : @players[0]
    win_checkmate(other_player)
    draw_stalemate(other_player)
    extra_commands(result, other_player)
  end

  def extra_commands(result, other_player)
    win_resign(result, other_player) if result.include?('resign')
    propose_draw(result, other_player) if result.include?('draw')
    save_game if result.include?('save')
    load_game if result.include?('load')
  end

  def propose_draw(result, other_player)
    return unless result.nil? == false && result.include?('draw')

    puts <<~HEREDOC
      #{@current_player.name} proposes a draw.
      Do you accept #{other_player.name}?
      Tpye [Y] for: yes I accept
      Tpye [N] for: no, I don't
    HEREDOC
    @winner = false if user_input == 'y'
    return unless @winner.nil?

    switch_players
  end

  def user_input
    loop do
      user_input = gets.chomp.downcase
      return user_input if user_input.match?(/[yn]/) && user_input.length == 1

      puts 'Please choose a valid option'
    end
  end

  def win_checkmate(other_player)
    return unless other_player.checkmate?

    @winner = @current_player
    @win_message = "Checkmate - #{@winner.name} wins the game!"
  end

  def draw_stalemate(other_player)
    return unless other_player.stalemate?

    @winner = false
    @draw_message = "It's a draw - stalemate"
  end

  def win_resign(result, other_player)
    return unless result.nil? == false && result.include?('resign')

    @winner = other_player
    @win_message = "#{@current_player.name} resigns - #{@winner.name} wins the game"
  end

  def save_game
    puts 'Saving your current game'
    savegame = [@board, @players, @current_player]
    saved_game = File.new 'saved_game.yml', 'w'
    saved_game.puts YAML.dump(savegame).to_s
    saved_game.close
    switch_players
  end

  def load_game
    loaded_game = ''
    File.readlines('saved_game.yml').each do |line|
      loaded_game += line
    end
    loaded_game = YAML.unsafe_load(loaded_game)
    @board = loaded_game[0]
    @players = loaded_game[1]
    @current_player = loaded_game[2]
    @board.game = self
    switch_players
  end
end
