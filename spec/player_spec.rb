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
end
