# frozen_string_literal: true

require_relative '../lib/player'

describe Player do
  subject(:player) { described_class.new }
  describe '#translate' do
    it 'trannslates a chess position into an array | a1 -> [0, 7]' do
      position = player.translate('a1')
      expect(position).to eq([0, 7])
    end
    it 'trannslates a chess position into an array | h8 -> [7, 0]' do
      position = player.translate('h8')
      expect(position).to eq([7, 0])
    end
    it 'trannslates a chess position into an array | d4 -> [3, 4]' do
      position = player.translate('d4')
      expect(position).to eq([3, 4])
    end
  end

  describe '#translate_back' do
    it 'trannslates an array into a chess position | [0, 7] -> a1' do
      position = player.translate_back([0, 7])
      expect(position).to eq('a1')
    end
    it 'trannslates an array into a chess position | [7, 0] -> h8' do
      position = player.translate_back([7, 0])
      expect(position).to eq('h8')
    end
    it 'trannslates an array into a chess position | [3, 4] -> d4' do
      position = player.translate_back([3, 4])
      expect(position).to eq('d4')
    end
  end

  describe '#decide' do
    let(:board) { double('board') }
    let(:knight) { double('knight') }
    before(:each) do
      player.instance_variable_set(:@board, board)
      allow(board).to receive(:at).and_return(knight)
      allow(knight).to receive(:color).and_return('white')
      allow(player).to receive(:puts)
      allow(board).to receive(:under_attack?).and_return(false)
    end
    it 'makes a move if given an field -> field input' do
      input = 'b1 -> a3'
      allow(board).to receive(:snapshot).and_return('1', '2')
      allow(player).to receive(:gets).and_return(input)
      expect(knight).to receive(:move).with([0, 5])
      player.decide
    end
    it "doesn't make a move if given an field -> field input" do
      input = 'b1 -> b3'
      allow(board).to receive(:snapshot).and_return('1', '2')
      allow(player).to receive(:gets).and_return(input)
      expect(knight).to receive(:move).with([1, 5])
      player.decide
    end
    it 'displays the error message if an invalid input is made' do
      error_message = 'Please choose again'
      input = 'b1 -> b3'
      allow(board).to receive(:snapshot).and_return('1', '1', '2')
      allow(player).to receive(:gets).and_return(input)
      allow(knight).to receive(:move)
      expect(player).to receive(:puts).with(error_message).once
      player.decide
    end
  end
end
