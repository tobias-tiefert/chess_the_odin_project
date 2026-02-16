# frozen_string_literal: true

require_relative '../lib/queen'

describe Queen do
  describe '#create_token' do
    subject(:white_queen) { described_class.new('white') }
    subject(:black_queen) { described_class.new('black') }
    subject(:no_arg_queen) { described_class.new('white') }

    it 'creates a white queen, if the color given is white' do
      expect(white_queen.token).to be '♕'
    end
    it 'creates a white queen, if no color is given' do
      expect(no_arg_queen.token).to be '♕'
    end
    it 'creates a black queen, if the color given is black' do
      expect(black_queen.token).to be '♛'
    end
  end

  describe '#moves' do
    context 'when on an empty field' do
      subject(:queen) { described_class.new('white') }
      let(:board) { double('board') }
      it 'finds all possible moves on the board for a corner position' do
        start_postion = [0, 0]

        queen.instance_variable_set(:@board, board)
        allow(board).to receive(:at).and_return(nil)
        possible_moves = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
                          [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                          [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]]
        moves = queen.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end

      it 'finds all possible moves on the board for a posiotion in the middle' do
        start_postion = [4, 3]
        queen.instance_variable_set(:@board, board)
        allow(board).to receive(:at).and_return(nil)
        possible_moves = [[0, 7], [1, 0], [1, 6], [2, 1], [2, 5], [3, 2],
                          [3, 4], [5, 2], [5, 4], [6, 1], [6, 5], [7, 0], [7, 6],
                          [0, 3], [1, 3], [2, 3], [3, 3], [5, 3], [6, 3], [7, 3],
                          [4, 0], [4, 1], [4, 2], [4, 4], [4, 5], [4, 6], [4, 7]]
        moves = queen.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
      it 'finds all possible moves on the board for a posiotion at the side' do
        start_postion = [0, 2]
        queen.instance_variable_set(:@board, board)
        allow(board).to receive(:at).and_return(nil)
        possible_moves = [[0, 0], [0, 1], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [1, 1], [1, 2], [1, 3], [2, 0],
                          [2, 2], [2, 4], [3, 2], [3, 5], [4, 2], [4, 6], [5, 2], [5, 7], [6, 2], [7, 2]]
        moves = queen.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
    end
    context "when on a field that's not empty" do
      subject(:queen) { described_class.new('white') }
      let(:board) { double('board') }
      let(:piece) { double('piece') }

      it 'only makes one move when there is an opponent arround (to strike)' do
        start_postion = [4, 3]
        queen.instance_variable_set(:@board, board)
        allow(board).to receive(:at).and_return(piece)
        allow(piece).to receive(:color).and_return('black')
        possible_moves = [[3, 2], [3, 4], [5, 2], [5, 4],
                          [3, 3], [5, 3], [4, 2], [4, 4]]
        moves = queen.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
      it "doesn't move when there are other pieces from the same color arround" do
        start_postion = [4, 3]
        queen.instance_variable_set(:@board, board)
        allow(board).to receive(:at).and_return(piece)
        allow(piece).to receive(:color).and_return('white')
        possible_moves = []
        moves = queen.moves(start_postion)
        expect(moves.sort).to eq(possible_moves.sort)
      end
    end
  end

  describe '#move' do
    subject(:queen) { described_class.new('white') }
    let(:board) { double('board') }
    let(:enemy_piece) { double('piece') }

    before(:each) do
      queen.board = board
      queen.position = [4, 4]
      allow(queen).to receive(:puts)
    end

    it "doesn't move the piece if given a target that shouldn't be reached" do
      allow(board).to receive(:at).and_return(nil)
      queen.move([3, 2])
      position_after = queen.instance_variable_get(:@position)
      expect(position_after).to eq [4, 4]
    end
    it "displays a message, if the move isn't a valid move" do
      allow(board).to receive(:at).and_return(nil)
      no_valid_move_message = "The white queen can't move there"
      expect(queen).to receive(:puts).with(no_valid_move_message)
      queen.move([3, 2])
    end
    it 'moves the piece to the target if it is a valid move' do
      empty_positions = [[], [], [], [], [], [], [], []]
      allow(board).to receive(:at).and_return(nil)
      allow(board).to receive(:positions).and_return(empty_positions)
      queen.move([3, 3])
      position_after = queen.instance_variable_get(:@position)
      expect(position_after).to eq [3, 3]
    end
    it 'diplays the strike message if the piece takes another piece with the move' do
      empty_positions = [[], [], [], [nil, nil, nil, enemy_piece], [], [], [], []]
      allow(board).to receive(:at).and_return(enemy_piece)
      allow(board).to receive(:positions).and_return(empty_positions)
      allow(enemy_piece).to receive(:color).and_return('black')
      allow(enemy_piece).to receive(:name).and_return('bishop')
      strike_message = 'The white queen took the black bishop'
      expect(queen).to receive(:puts).with(strike_message)
      queen.move([3, 3])
    end
  end
end
