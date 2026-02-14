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
      allow(board).to receive(:element).and_return(nil)
      possible_moves = [[4, 5], [4, 4]]
      moves = white_pawn.moves(start_postion)
      expect(moves.sort).to eq(possible_moves.sort)
    end
    it 'finds the move and the long move positions for black on an empty field' do
      start_postion = [4, 1]

      black_pawn.instance_variable_set(:@board, board)
      black_pawn.instance_variable_set(:@position, start_postion)
      allow(board).to receive(:element).and_return(nil)
      possible_moves = [[4, 2], [4, 3]]
      moves = black_pawn.moves
      expect(moves.sort).to eq(possible_moves.sort)
    end
    it 'finds all options for white' do
      start_postion = [4, 6]

      white_pawn.instance_variable_set(:@board, board)
      white_pawn.instance_variable_set(:@position, start_postion)
      allow(board).to receive(:element).and_return(nil, nil, black_piece, black_piece)
      allow(black_piece).to receive(:color).and_return('black')
      possible_moves = [[4, 5], [4, 4], [3, 5], [5, 5]]
      moves = white_pawn.moves
      expect(moves.sort).to eq(possible_moves.sort)
    end
    it 'finds all options for black' do
      start_postion = [4, 1]

      black_pawn.instance_variable_set(:@board, board)
      black_pawn.instance_variable_set(:@position, start_postion)
      allow(board).to receive(:element).and_return(nil, nil, white_piece, white_piece)
      allow(white_piece).to receive(:color).and_return('white')
      possible_moves = [[4, 2], [4, 3], [3, 2], [5, 2]]
      moves = black_pawn.moves
      expect(moves.sort).to eq(possible_moves.sort)
    end
    it "won't show the long move if the white pawn is blocked" do
      start_postion = [4, 6]

      white_pawn.instance_variable_set(:@board, board)
      white_pawn.instance_variable_set(:@position, start_postion)
      allow(board).to receive(:element).and_return(white_piece, nil, nil, nil)
      possible_moves = []
      moves = white_pawn.moves(start_postion)
      expect(moves.sort).to eq(possible_moves.sort)
    end
    it "won't show the long move if the white pawn is blocked" do
      start_postion = [4, 1]

      black_pawn.instance_variable_set(:@board, board)
      black_pawn.instance_variable_set(:@position, start_postion)
      allow(board).to receive(:element).and_return(white_piece, nil, nil, nil)
      possible_moves = []
      moves = black_pawn.moves
      expect(moves.sort).to eq(possible_moves.sort)
    end
    it "doesn't show the long move if the pawn moved before" do
      start_postion = [4, 5]

      white_pawn.instance_variable_set(:@board, board)
      white_pawn.instance_variable_set(:@position, start_postion)
      white_pawn.instance_variable_set(:@moved, true)
      allow(board).to receive(:element).and_return(nil, black_piece, black_piece)
      allow(black_piece).to receive(:color).and_return('black')
      possible_moves = [[4, 4], [3, 4], [5, 4]]
      moves = white_pawn.moves
      expect(moves.sort).to eq(possible_moves.sort)
    end
  end
end
