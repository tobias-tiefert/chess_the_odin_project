# frozen_string_literal: true

require_relative '../lib/bishop'

describe Bishop do
  describe '#create_token' do
    subject(:white_bishop) { described_class.new('white') }
    subject(:black_bishop) { described_class.new('black') }
    subject(:no_arg_bishop) { described_class.new('white') }

    it 'creates a white bishop, if the color given is white' do
      expect(white_bishop.token).to be '♗'
    end
    it 'creates a white bishop, if no color is given' do
      expect(no_arg_bishop.token).to be '♗'
    end
    it 'creates a black bishop, if the color given is black' do
      expect(black_bishop.token).to be '♝'
    end
  end

  describe '#moves' do
    context 'when on an empty field' do
      subject(:bishop) { described_class.new('white') }
      let(:board) { double('board') }
      it 'finds all possible moves on the board for a corner position' do
        start_postion = [0, 0]

        bishop.instance_variable_set(:@board, board)
        allow(board).to receive(:element).and_return(nil)
        possible_moves = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]]
        moves = bishop.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end

      it 'finds all possible moves on the board for a posiotion in the middle' do
        start_postion = [4, 3]
        bishop.instance_variable_set(:@board, board)
        allow(board).to receive(:element).and_return(nil)
        possible_moves = [[0, 7], [1, 0], [1, 6], [2, 1], [2, 5], [3, 2],
                          [3, 4], [5, 2], [5, 4], [6, 1], [6, 5], [7, 0], [7, 6]]
        moves = bishop.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
    end
    context "when on a field that's not empty" do
      subject(:bishop) { described_class.new('white') }
      let(:board) { double('board') }
      let(:piece) { double('piece') }

      it 'only makes one move when there is an opponent arround (to strike)' do
        start_postion = [4, 3]
        bishop.instance_variable_set(:@board, board)
        allow(board).to receive(:element).and_return(piece)
        allow(piece).to receive(:color).and_return('black')
        possible_moves = [[3, 2], [3, 4],
                          [5, 2], [5, 4]]
        moves = bishop.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
      it "doesn't move when there are other pieces from the same color arround" do
        start_postion = [4, 3]
        bishop.instance_variable_set(:@board, board)
        allow(board).to receive(:element).and_return(piece)
        allow(piece).to receive(:color).and_return('white')
        possible_moves = []
        moves = bishop.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
    end
  end
end
