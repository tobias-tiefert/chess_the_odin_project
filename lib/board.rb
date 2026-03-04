# frozen_string_literal: true

require_relative 'pawn'
require_relative 'king'
require_relative 'queen'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'dummy_pawn'

# class that represents the board in the chess game
class Board
  COLUMNS = 8
  ROWS = 8
  ROW_POSITIONS = "\e[0m        a  b  c  d  e  f  g  h  "
  BLACK_FIELD = "\e[43m"
  WHITE_FIELD = "\e[107m"

  attr_accessor :positions
  attr_writer :game

  def initialize(game = nil)
    @game = game
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

  def snapshot
    output = ''
    @positions.flatten.each do |field|
      field_sign = if field.nil? || field.is_a?(DummyPawn)
                     '-'
                   else
                     field.token
                   end
      output += field_sign
    end
    output
  end

  def copy(old_board = self)
    new_board = Board.new
    copy_positions(old_board, new_board)
    copy_dummy_pawn(old_board, new_board)
    new_board
  end

  def copy_casteling(old_board, new_board)
    new_board.king('white').castled = old_board.king('white').castled
    new_board.king('black').castled = old_board.king('black').castled
  end

  def copy_dummy_pawn(old_board, new_board)
    return if old_board.dummy_pawn.nil?

    old_dummy = old_board.dummy_pawn
    new_dummy = DummyPawn.new(old_dummy.pawn_position, old_dummy.color)
    new_board.put_on_board(new_dummy, old_dummy.position)
  end

  def remove_dummy
    return if dummy_pawn.nil?

    position = dummy_pawn.position
    @positions[position[1]][position[0]] = nil
  end

  def copy_positions(old_board, new_board)
    lines = lines(old_board.snapshot)
    lines.each_with_index do |line, y_postion|
      line.chars.each_with_index do |char, x_position|
        next if char == '-'

        element = revert_char(char)
        new_board.put_on_board(element, [x_position, y_postion])
      end
    end
  end

  def king(color)
    @positions.flatten.compact.select { |piece| piece.color == color && piece.is_a?(King) }.first
  end

  def dummy_pawn
    @positions.flatten.compact.select { |piece| piece.is_a?(DummyPawn) }.first
  end

  def revert_char(char)
    case char
    when '♜' then Rook.new('black')
    when '♞' then Knight.new('black')
    when '♝' then Bishop.new('black')
    when '♛' then Queen.new('black')
    when '♚' then King.new('black')
    when '♟' then Pawn.new('black')
    when '♖' then Rook.new('white')
    when '♘' then Knight.new('white')
    when '♗' then Bishop.new('white')
    when '♕' then Queen.new('white')
    when '♔' then King.new('white')
    when '♙' then Pawn.new('white')
    end
  end

  # Splits the snapshot sting into 8 lines (strings) and puts them into an arry
  def lines(snapshot)
    lines = []
    8.times do
      line = snapshot[0..7]
      lines << line
      snapshot = snapshot[8..snapshot.length]
    end
    lines
  end

  def under_attack?(field, color)
    opponent_color = color == 'white' ? 'black' : 'white'
    opponent_pieces = all(opponent_color)
    opponent_pieces.any? do |piece|
      piece.moves.include?(field)
    end
  end

  def all(color = nil)
    if color.nil?
      @positions.flatten.compact.select do |piece|
        piece.is_a?(Piece)
      end
    else
      @positions.flatten.compact.select do |piece|
        piece.is_a?(Piece) && piece.color == color
      end
    end
  end

  private

  def set_up_pieces(color)
    side = color == 'white' ? 7 : 0
    put_on_board(Queen.new(color), [3, side])
    put_on_board(King.new(color), [4, side])
    set_up_rooks(color, side)
    set_up_knights(color, side)
    set_up_bishops(color, side)
    set_up_pawns(color)
  end

  def game_king(color)
    color == 'white' ? @game.players[0].king : @game.players[1].king
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
