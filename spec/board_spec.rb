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

  describe '#snapshot' do
    let(:rook) { double('rook') }
    let(:queen) { double('queen') }
    let(:knight) { double('knight') }
    it "creats a snaptshot of the board's positions as a string | one piece" do
      allow(rook).to receive(:token).and_return('♜')
      test_positions = [[nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, rook]]
      board.positions = test_positions
      expected_result = '---------------------------------------------------------------♜'
      snapshot = board.snapshot
      expect(snapshot).to eq expected_result
    end
    it "creats a snaptshot of the board's positions as a string | three pieces" do
      allow(rook).to receive(:token).and_return('♜')
      allow(queen).to receive(:token).and_return('♛')
      allow(knight).to receive(:token).and_return('♘')
      test_positions = [[queen, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, knight, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, rook]]
      board.positions = test_positions
      expected_result = '♛--------------------------♘-----------------------------------♜'
      snapshot = board.snapshot
      expect(snapshot).to eq expected_result
    end
  end

  describe '#all' do
    let(:white_knight) { double('knight') }
    let(:white_queen) { double('queen') }
    let(:white_rook) { double('rook') }
    let(:black_king) { double('king') }
    let(:black_pawn1) { double('pawn') }
    let(:black_pawn2) { double('pawn') }

    before(:each) do
      allow(white_knight).to receive(:color).and_return('white')
      allow(white_queen).to receive(:color).and_return('white')
      allow(white_rook).to receive(:color).and_return('white')
      allow(black_king).to receive(:color).and_return('black')
      allow(black_pawn1).to receive(:color).and_return('black')
      allow(black_pawn2).to receive(:color).and_return('black')
    end

    it 'returns all white pieces' do
      test_positions = [[white_queen, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, white_knight, nil, nil, nil, nil],
                        [nil, nil, black_king, nil, nil, nil, nil, nil],
                        [nil, nil, black_pawn1, nil, nil, nil, nil, nil],
                        [nil, nil, black_pawn2, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, white_rook]]
      board.positions = test_positions
      result = board.all('white')
      expectation = [white_queen, white_knight, white_rook]
      expect(result).to eq expectation
    end
    it 'returns all black pieces' do
      test_positions = [[white_queen, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, white_knight, nil, nil, nil, nil],
                        [nil, nil, black_king, nil, nil, nil, nil, nil],
                        [nil, nil, black_pawn1, nil, nil, nil, nil, nil],
                        [nil, nil, black_pawn2, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, white_rook]]
      board.positions = test_positions
      result = board.all('black')
      expectation = [black_king, black_pawn1, black_pawn2]
      expect(result).to eq expectation
    end
    it 'returns all pieces when no argument is given' do
      test_positions = [[white_queen, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, white_knight, nil, nil, nil, nil],
                        [nil, nil, black_king, nil, nil, nil, nil, nil],
                        [nil, nil, black_pawn1, nil, nil, nil, nil, nil],
                        [nil, nil, black_pawn2, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, white_rook]]
      board.positions = test_positions
      result = board.all
      expectation = [white_queen, white_knight, black_king, black_pawn1, black_pawn2, white_rook]
      expect(result).to eq expectation
    end
    it 'returns an empty array if the positions are empty' do
      test_positions = [[nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil]]
      board.positions = test_positions
      result = board.all('black')
      expectation = []
      expect(result).to eq expectation
    end
  end

  describe '#under_attack?' do
    let(:white_queen) { double('queen') }
    let(:black_rook) { double('rook') }
    before(:each) do
      test_positions = [[black_rook, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, white_queen]]
      queen_moves = [[7, 6], [7, 5], [7, 4], [7, 3], [7, 2], [7, 1], [7, 0], [6, 7], [5, 7], [4, 7], [3, 7], [2, 7],
                     [1, 7], [0, 7], [6, 6], [5, 5], [4, 4], [3, 3], [2, 2], [1, 1], [0, 0]]
      rook_moves = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0],
                    [6, 0], [7, 0]]
      board.positions = test_positions
      allow(white_queen).to receive(:color).and_return('white')
      allow(black_rook).to receive(:color).and_return('black')
      allow(white_queen).to receive(:moves).and_return(queen_moves)
      allow(black_rook).to receive(:moves).and_return(rook_moves)
    end
    it 'returns true if a field is under attack' do
      expect(board.under_attack?([0, 0], 'black')).to be true
    end
    it 'returns false if a field is not under attak, because the piece that could reach it has the wrong color' do
      expect(board.under_attack?([0, 0], 'white')).to be false
    end
    it 'returns false if a field is not under attack' do
      expect(board.under_attack?([7, 7], 'white')).to be false
    end
  end
end
