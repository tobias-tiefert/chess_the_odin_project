# frozen_string_literal: true

require_relative '../lib/king'

describe King do
  describe '#create_token' do
    subject(:white_king) { described_class.new('white') }
    subject(:black_king) { described_class.new('black') }
    subject(:no_arg_king) { described_class.new('white') }

    it 'creates a white king, if the color given is white' do
      expect(white_king.token).to be '♔'
    end
    it 'creates a white king, if no color is given' do
      expect(no_arg_king.token).to be '♔'
    end
    it 'creates a black king, if the color given is black' do
      expect(black_king.token).to be '♚'
    end
  end

  describe '#moves' do
    context 'when on an empty field' do
      subject(:king) { described_class.new('white') }
      let(:board) { double('board') }
      it 'finds all possible moves on the board for a corner position' do
        start_postion = [0, 0]

        king.instance_variable_set(:@board, board)
        allow(board).to receive(:at).and_return(nil)
        possible_moves = [[1, 1], [0, 1], [1, 0]]
        moves = king.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end

      it 'finds all possible moves on the board for a posiotion in the middle' do
        start_postion = [4, 3]
        king.instance_variable_set(:@board, board)
        allow(board).to receive(:at).and_return(nil)
        possible_moves = [[3, 2], [4, 2], [5, 2], [5, 3], [5, 4], [4, 4], [3, 4], [3, 3]]
        moves = king.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
    end
    context "when on a field that's not empty" do
      subject(:king) { described_class.new('white') }
      let(:board) { double('board') }
      let(:piece) { double('piece') }

      it 'it moves on fields with the enemy (to strike)' do
        start_postion = [4, 3]
        king.instance_variable_set(:@board, board)
        allow(board).to receive(:at).and_return(piece)
        allow(piece).to receive(:color).and_return('black')
        possible_moves = [[3, 2], [3, 4], [5, 2], [5, 4],
                          [3, 3], [5, 3], [4, 2], [4, 4]]
        moves = king.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
      it "doesn't move when there are other pieces from the same color on the target field" do
        start_postion = [4, 3]
        king.instance_variable_set(:@board, board)
        allow(board).to receive(:at).and_return(piece)
        allow(piece).to receive(:color).and_return('white')
        possible_moves = []
        moves = king.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
    end
  end
end
