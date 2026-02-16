# frozen_string_literal: true

# super class for all the pieces in the chess game
class Piece
  attr_reader :color, :token, :name
  attr_writer :board, :position

  WHITE_TOKEN = '♙'
  BLACK_TOKEN = '♟'

  def initialize(color = 'white', board = nil)
    @name = 'Piece'
    @color = color
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
      field_element_color = @board.at(new_position).nil? ? 'empty' : @board.at(new_position).color

      output << new_position if on_the_board?(new_position) && field_element_color != @color
    end
    output.sort
  end

  def new_position(position, position_change)
    [position[0] + position_change[0], position[1] + position_change[1]]
  end

  def move(target)
    moves.include?(target) ? perform_move(target) : no_valid_move_message
  end

  private

  def perform_move(target)
    target_field = @board.at(target)
    update_board(target)
    strike_message(target_field) unless target_field.nil?
    @moved = true
  end

  def update_board(target)
    @board.positions[@position[1]][@position[0]] = nil
    @position = target
    @board.positions[target[1]][target[0]] = self
  end

  def strike_message(target)
    puts "The #{@color} #{@name.downcase} took the #{target.color} #{target.name.downcase}"
  end

  def no_valid_move_message
    puts "The #{@color} #{@name.downcase} can't move there"
  end
end
