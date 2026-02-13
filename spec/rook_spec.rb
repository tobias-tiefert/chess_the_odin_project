# frozen_string_literal: true

require_relative '../lib/rook'

describe Rook do
  describe '#create_token' do
    subject(:white_rook) { described_class.new('white') }
    subject(:black_rook) { described_class.new('black') }
    subject(:no_arg_rook) { described_class.new('white') }

    it 'creates a white rook, if the color given is white' do
      expect(white_rook.token).to be '♖'
    end
    it 'creates a white rook, if no color is given' do
      expect(no_arg_rook.token).to be '♖'
    end
    it 'creates a black rook, if the color given is black' do
      expect(black_rook.token).to be '♜'
    end
  end

  describe '#moves' do
    context 'when on an empty field' do
      subject(:rook) { described_class.new('white') }
      let(:board) { double('board') }
      it 'finds all possible moves on the board for a corner position' do
        start_postion = [0, 0]

        rook.instance_variable_set(:@board, board)
        allow(board).to receive(:element).and_return(nil)
        possible_moves = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                          [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]]
        moves = rook.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end

      it 'finds all possible moves on the board for a posiotion in the middle' do
        start_postion = [4, 3]
        rook.instance_variable_set(:@board, board)
        allow(board).to receive(:element).and_return(nil)
        possible_moves = [[0, 3], [1, 3], [2, 3], [3, 3], [5, 3], [6, 3], [7, 3],
                          [4, 0], [4, 1], [4, 2], [4, 4], [4, 5], [4, 6], [4, 7]]
        moves = rook.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
    end
    context "when on a field that's not empty" do
      subject(:rook) { described_class.new('white') }
      let(:board) { double('board') }
      let(:piece) { double('piece') }

      it 'only makes one move when there is an opponent arround (to strike)' do
        start_postion = [4, 3]
        rook.instance_variable_set(:@board, board)
        allow(board).to receive(:element).and_return(piece)
        allow(piece).to receive(:color).and_return('black')
        possible_moves = [[3, 3], [5, 3],
                          [4, 2], [4, 4]]
        moves = rook.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
      it "doesn't move when there are other pieces from the same color arround" do
        start_postion = [4, 3]
        rook.instance_variable_set(:@board, board)
        allow(board).to receive(:element).and_return(piece)
        allow(piece).to receive(:color).and_return('white')
        possible_moves = []
        moves = rook.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
    end
  end
end
