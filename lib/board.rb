# frozen_string_literal: true

require_relative 'pawn'
require_relative 'king'
require_relative 'queen'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'

# class that represents the board in the chess game
class Board
  COLUMNS = 8
  ROWS = 8
  ROW_POSITIONS = "\e[0m        a  b  c  d  e  f  g  h  "
  BLACK_FIELD = "\e[43m"
  WHITE_FIELD = "\e[107m"

  attr_accessor :positions

  def initialize
    @positions = initialize_positions
  end

  def initialize_positions
    rows = []
    COLUMNS.times do
      column = Array.new(ROWS, nil)
      rows << column
    end
    rows
  end

  def at(position)
    @positions[position[1]][position[0]]
  end

  def draw_board(positions = @positions)
    puts ROW_POSITIONS
    positions.each_with_index { |row, index| draw_row(row, index) }
    puts ROW_POSITIONS
  end

  def put_on_board(piece, position)
    @positions[position[1]][position[0]] = piece
    piece.position = position
    piece.board = self
  end

  def set_up
    set_up_pieces('white')
    set_up_pieces('black')
  end

  private

  def set_up_pieces(color)
    side = color == 'white' ? 7 : 0
    put_on_board(King.new(color), [4, side])
    put_on_board(Queen.new(color), [3, side])
    set_up_rooks(color, side)
    set_up_knights(color, side)
    set_up_bishops(color, side)
    set_up_pawns(color)
  end

  def set_up_rooks(color, side)
    put_on_board(Rook.new(color), [0, side])
    put_on_board(Rook.new(color), [7, side])
  end

  def set_up_knights(color, side)
    put_on_board(Knight.new(color), [1, side])
    put_on_board(Knight.new(color), [6, side])
  end

  def set_up_bishops(color, side)
    put_on_board(Bishop.new(color), [2, side])
    put_on_board(Bishop.new(color), [5, side])
  end

  def set_up_pawns(color)
    pawn_line = color == 'white' ? 6 : 1
    8.times do |count|
      put_on_board(Pawn.new(color), [count, pawn_line])
    end
  end

  def draw_row(row, index)
    print '    ' # just to indent everything so it looks better in the terminal
    draw_index(index)
    row_type = index.odd? ? 'odd' : 'even'
    draw_fields(row, row_type)
    draw_index(index)
    print "\e[0m\n"
  end

  def draw_fields(row, type)
    print "\e[30m"
    background_color1 = type == 'odd' ? WHITE_FIELD : BLACK_FIELD
    background_color2 = type == 'odd' ? BLACK_FIELD : WHITE_FIELD
    row.each_with_index do |field, field_index|
      background_color = field_index.odd? ? background_color1 : background_color2
      field_token = field.nil? ? ' ' : field.token
      print "#{background_color} #{field_token} "
    end
  end

  def draw_index(index)
    chess_index = (index - 8).abs
    print "\e[0m #{chess_index} "
  end
end
