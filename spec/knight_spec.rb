# frozen_string_literal: true

require_relative '../lib/knight'

describe Knight do
  describe '#create_token' do
    subject(:white_knight) { described_class.new('white') }
    subject(:black_knight) { described_class.new('black') }
    subject(:no_arg_knight) { described_class.new('white') }

    it 'creates a white knight, if the color given is white' do
      expect(white_knight.token).to be '♘'
    end
    it 'creates a white knight, if no color is given' do
      expect(no_arg_knight.token).to be '♘'
    end
    it 'creates a black knight, if the color given is black' do
      expect(black_knight.token).to be '♞'
    end
  end

  describe '#moves' do
    context 'when on an empty field' do
      subject(:knight) { described_class.new('white') }
      let(:board) { double('board') }
      it 'finds all possible moves on the board for a corner position' do
        start_postion = [0, 0]

        knight.instance_variable_set(:@board, board)
        allow(board).to receive(:at).and_return(nil)
        possible_moves = [[1, 2], [2, 1]]
        moves = knight.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end

      it 'finds all possible moves on the board for a posiotion in the middle' do
        start_postion = [4, 3]
        knight.instance_variable_set(:@board, board)
        allow(board).to receive(:at).and_return(nil)
        possible_moves = [[2, 2], [2, 4], [3, 1], [3, 5], [5, 1], [5, 5], [6, 2], [6, 4]]
        moves = knight.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
    end
    context "when on a field that's not empty" do
      subject(:knight) { described_class.new('white') }
      let(:board) { double('board') }
      let(:piece) { double('piece') }

      it 'it moves on fields with the enemy (to strike)' do
        start_postion = [4, 3]
        knight.instance_variable_set(:@board, board)
        allow(board).to receive(:at).and_return(piece)
        allow(piece).to receive(:color).and_return('black')
        possible_moves = [[2, 2], [2, 4], [3, 1], [3, 5], [5, 1], [5, 5], [6, 2], [6, 4]]
        moves = knight.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
      it "doesn't move when there are other pieces from the same color on the target field" do
        start_postion = [4, 3]
        knight.instance_variable_set(:@board, board)
        allow(board).to receive(:at).and_return(piece)
        allow(piece).to receive(:color).and_return('white')
        possible_moves = []
        moves = knight.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
    end
  end
end
