# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }
  describe '#initialize_positions' do
    it 'creates an array' do
      test_board = board.initialize_positions
      expect(test_board).to be_a_kind_of Array
    end
    it 'creates an array with 8 entries' do
      test_board = board.initialize_positions
      expect(test_board.length).to be 8
    end
    it 'creates a 2-dimensional array' do
      test_board = board.initialize_positions
      expect(test_board.all? { |element| element.is_a?(Array) }).to be true
    end
    it 'the 2nd dimension arrays have 8 elements' do
      test_board = board.initialize_positions
      expect(test_board[1].length).to be 8
    end
    it 'all elements of the 2nd dimension are nil' do
      test_board = board.initialize_positions
      expect(test_board[5].all?(&:nil?)).to be true
    end
  end
  describe '#at' do
    test_positions = [
      [89, nil, 4, nil],
      [6, 7, 'hallo', nil]
    ]
    it 'returns an element' do
      board.instance_variable_set(:@positions, test_positions)
      element = board.at([2, 1])
      expect(element).to eq('hallo')
    end
  end
  describe '#put_on_board' do
    let(:rook) { double('rook') }
    it 'puts the piece on the board' do
      allow(rook).to receive(:board=)
      allow(rook).to receive(:position=)
      board.put_on_board(rook, [0, 0])
      expect(board.at([0, 0])).to be rook
    end
  end

  describe '#set_up' do
    it 'creates white elements on the white side (6 and 7)' do
      board.set_up
      pawn_lines = board.positions[6] + board.positions[7]
      expect(pawn_lines.all? { |element| element.color == 'white' }).to be true
    end
    it 'creates black elements on the black side (0 and 1)' do
      board.set_up
      pawn_lines = board.positions[0] + board.positions[1]
      expect(pawn_lines.all? { |element| element.color == 'black' }).to be true
    end
    it 'creates pawns on line 6 and line 1' do
      board.set_up
      pawn_lines = board.positions[6] + board.positions[1]
      expect(pawn_lines.all? { |element| element.is_a?(Pawn) }).to be(true)
    end
    it 'creates two kings and puts them on their positions' do
      board.set_up
      kings = [board.positions[0][4], board.positions[7][4]]
      expect(kings.all? { |element| element.is_a?(King) }).to be(true)
    end
    it 'creates two queens and puts them on their positions' do
      board.set_up
      queens = [board.positions[0][3], board.positions[7][3]]
      expect(queens.all? { |element| element.is_a?(Queen) }).to be(true)
    end
    it 'creates four rooks and puts them on their positions' do
      board.set_up
      rooks = [board.positions[0][0], board.positions[0][7], board.positions[7][0], board.positions[7][7]]
      expect(rooks.all? { |element| element.is_a?(Rook) }).to be(true)
    end
    it 'creates four knights and puts them on their positions' do
      board.set_up
      knights = [board.positions[0][1], board.positions[0][6], board.positions[7][1], board.positions[7][6]]
      expect(knights.all? { |element| element.is_a?(Knight) }).to be(true)
    end
    it 'creates four bishops and puts them on their positions' do
      board.set_up
      bishops = [board.positions[0][2], board.positions[0][5], board.positions[7][2], board.positions[7][5]]
      expect(bishops.all? { |element| element.is_a?(Bishop) }).to be(true)
    end
  end
end
