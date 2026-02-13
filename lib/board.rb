# frozen_string_literal: true

# class that represents the board in the chess game
class Board
  COLUMNS = 8
  ROWS = 8
  ROW_POSITIONS = "\e[0m        a  b  c  d  e  f  g  h  "
  BLACK_FIELD = "\e[43m"
  WHITE_FIELD = "\e[107m"

  attr_reader :postions

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

  def draw_board(positions = @positions)
    puts ROW_POSITIONS
    positions.each_with_index { |row, index| draw_row(row, index) }
    puts ROW_POSITIONS
  end

  private

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
