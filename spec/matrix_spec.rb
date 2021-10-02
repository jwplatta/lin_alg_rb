require 'spec_helper'

describe LinAlgRb::Matrix do
  describe '#[]' do
    it 'return value at index' do
      coordinates = [1,2,3,4]
      matrix = described_class.new(coordinates)

      expect(matrix[0]).to eq(coordinates)
    end
  end
end