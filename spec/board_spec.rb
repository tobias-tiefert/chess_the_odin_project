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
  describe '#elemen' do
    test_positions = [
      [nil, nil, 4, nil],
      [6, 7, 'hallo', nil]
    ]
    it 'returns an element' do
      board.instance_variable_set(:@positions, test_positions)
      element = board.element([1, 2])
      expect(element).to eq('hallo')
    end
  end
end
