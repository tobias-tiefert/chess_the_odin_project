# frozen_string_literal: true

require_relative 'translate'
require_relative 'dummy_pawn'

# super class for all the pieces in the chess game
class Piece
  attr_reader :color, :token, :name, :moved
  attr_writer :board
  attr_accessor :position

  include TRANSLATE

  WHITE_TOKEN = '♙'
  BLACK_TOKEN = '♟'

  def initialize(color = 'white', board = nil)
    @name = 'Piece'
    @color = color
    @opponent_color = opponent_color
    @position = nil
    @board = board
    @token = create_token(color, WHITE_TOKEN, BLACK_TOKEN)
    @moved = false
  end

  def create_token(color, token1, token2)
    color == 'white' ? token1 : token2
  end

  def on_the_board?(position)
    position[0].between?(0, 7) && position[1].between?(0, 7)
  end

  def moves(position = @position, directions = @directions)
    output = []
    directions.each do |direction|
      new_position = new_position(position, direction)
      next unless on_the_board?(new_position)

      target_field = @board.at(new_position)

      if on_the_board?(new_position) && free_field?(target_field) || opponent_field?(target_field)
        output << new_position
      end
    end
    output.sort
  end

  def opponent_field?(field_element)
    return false if field_element.nil?

    field_element.color == @opponent_color && field_element.is_a?(Piece)
  end

  def free_field?(field_element)
    field_element.nil? || field_element.is_a?(DummyPawn)
  end

  def opponent_color
    @color == 'white' ? 'black' : 'white'
  end

  def new_position(position, position_change)
    [position[0] + position_change[0], position[1] + position_change[1]]
  end

  def move(target)
    if moves.include?(target)
      @board.remove_dummy
      perform_move(target)
    else
      no_valid_move_message(target)
    end
  end

  def test_move(target)
    return unless moves.include?(target)

    perform_test_move(target)
    @board.remove_dummy
  end

  def perform_move(target)
    target_field = @board.at(target)
    update_board(target)
    strike_message(target_field) unless target_field.nil?
    @moved = true
  end

  private

  def perform_test_move(target)
    update_board(target)
  end

  def update_board(target)
    @board.positions[@position[1]][@position[0]] = nil
    @position = target
    @board.positions[target[1]][target[0]] = self
  end

  def strike_message(target)
    puts "The #{@color} #{@name.downcase} took the #{target.color} #{target.name.downcase}"
  end

  def no_valid_move_message(target)
    puts "The #{@color} #{@name.downcase} can't move form #{translate_back(@position)} to #{translate_back(target)}"
  end
end
