# frozen_string_literal: true

require_relative '../lib/pawn'

describe Pawn do
  describe '#create_token' do
    subject(:white_pawn) { described_class.new('white') }
    subject(:black_pawn) { described_class.new('black') }
    subject(:no_arg_pawn) { described_class.new('white') }

    it 'creates a white pawn, if the color given is white' do
      expect(white_pawn.token).to be '♙'
    end
    it 'creates a white pawn, if no color is given' do
      expect(no_arg_pawn.token).to be '♙'
    end
    it 'creates a black pawn, if the color given is black' do
      expect(black_pawn.token).to be '♟'
    end
  end

  describe '#moves' do
    subject(:white_pawn) { described_class.new('white') }
    subject(:black_pawn) { described_class.new('black') }
    let(:board) { double('board') }
    let(:white_piece) { double('piece') }
    let(:black_piece) { double('piece') }
    it 'finds the move and the long move positions for white on an empty field' do
      start_postion = [4, 6]

      white_pawn.instance_variable_set(:@board, board)
      white_pawn.instance_variable_set(:@position, start_postion)
      allow(board).to receive(:at).and_return(nil)
      possible_moves = [[4, 5], [4, 4]]
      moves = white_pawn.moves(start_postion)
      expect(moves.sort).to eq(possible_moves.sort)
    end
    it 'finds the move and the long move positions for black on an empty field' do
      start_postion = [4, 1]

      black_pawn.instance_variable_set(:@board, board)
      black_pawn.instance_variable_set(:@position, start_postion)
      allow(board).to receive(:at).and_return(nil)
      possible_moves = [[4, 2], [4, 3]]
      moves = black_pawn.moves
      expect(moves.sort).to eq(possible_moves.sort)
    end
    it 'finds all options for white' do
      start_postion = [4, 6]

      white_pawn.instance_variable_set(:@board, board)
      white_pawn.instance_variable_set(:@position, start_postion)
      allow(board).to receive(:at).and_return(nil, nil, black_piece, black_piece)
      allow(black_piece).to receive(:color).and_return('black')
      possible_moves = [[4, 5], [4, 4], [3, 5], [5, 5]]
      moves = white_pawn.moves
      expect(moves.sort).to eq(possible_moves.sort)
    end
    it 'finds all options for black' do
      start_postion = [4, 1]

      black_pawn.instance_variable_set(:@board, board)
      black_pawn.instance_variable_set(:@position, start_postion)
      allow(board).to receive(:at).and_return(nil, nil, white_piece, white_piece)
      allow(white_piece).to receive(:color).and_return('white')
      possible_moves = [[4, 2], [4, 3], [3, 2], [5, 2]]
      moves = black_pawn.moves
      expect(moves.sort).to eq(possible_moves.sort)
    end
    it "won't show the long move if the white pawn is blocked" do
      start_postion = [4, 6]

      white_pawn.instance_variable_set(:@board, board)
      white_pawn.instance_variable_set(:@position, start_postion)
      allow(board).to receive(:at).and_return(white_piece, nil, nil, nil)
      possible_moves = []
      moves = white_pawn.moves(start_postion)
      expect(moves.sort).to eq(possible_moves.sort)
    end
    it "won't show the long move if the white pawn is blocked" do
      start_postion = [4, 1]

      black_pawn.instance_variable_set(:@board, board)
      black_pawn.instance_variable_set(:@position, start_postion)
      allow(board).to receive(:at).and_return(white_piece, nil, nil, nil)
      possible_moves = []
      moves = black_pawn.moves
      expect(moves.sort).to eq(possible_moves.sort)
    end
    it "doesn't show the long move if the pawn moved before" do
      start_postion = [4, 5]

      white_pawn.instance_variable_set(:@board, board)
      white_pawn.instance_variable_set(:@position, start_postion)
      white_pawn.instance_variable_set(:@moved, true)
      allow(board).to receive(:at).and_return(nil, black_piece, black_piece)
      allow(black_piece).to receive(:color).and_return('black')
      possible_moves = [[4, 4], [3, 4], [5, 4]]
      moves = white_pawn.moves
      expect(moves.sort).to eq(possible_moves.sort)
    end
  end
  describe '#move' do
    subject(:pawn) { described_class.new('white') }
    let(:board) { double('board') }
    let(:enemy_piece) { double('piece') }

    before(:each) do
      pawn.board = board
      pawn.position = [4, 4]
      allow(pawn).to receive(:puts)
    end

    it "doesn't move the piece if given a target that shouldn't be reached" do
      allow(board).to receive(:at).and_return(nil)
      pawn.move([3, 3])
      position_after = pawn.instance_variable_get(:@position)
      expect(position_after).to eq [4, 4]
    end
    it "displays a message, if the move isn't a valid move" do
      allow(board).to receive(:at).and_return(nil)
      no_valid_move_message = "The white pawn can't move there"
      expect(pawn).to receive(:puts).with(no_valid_move_message)
      pawn.move([3, 3])
    end
    it 'moves the piece to the target if it is a valid move' do
      empty_positions = [[], [], [], [], [], [], [], []]
      allow(board).to receive(:at).and_return(nil)
      allow(board).to receive(:positions).and_return(empty_positions)
      pawn.move([4, 3])
      position_after = pawn.instance_variable_get(:@position)
      expect(position_after).to eq [4, 3]
    end
    it 'diplays the strike message if the piece takes another piece with the move' do
      empty_positions = [[], [], [], [nil, nil, nil, enemy_piece], [], [], [], []]
      allow(board).to receive(:at).and_return(enemy_piece)
      allow(board).to receive(:positions).and_return(empty_positions)
      allow(enemy_piece).to receive(:color).and_return('black')
      allow(enemy_piece).to receive(:name).and_return('bishop')
      strike_message = 'The white pawn took the black bishop'
      expect(pawn).to receive(:puts).with(strike_message)
      pawn.move([3, 3])
    end
  end
end
