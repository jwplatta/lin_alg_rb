require 'spec_helper'

describe LinAlgRb::Line do
  describe '#find_basepoint' do
    it do
      vect = LinAlgRb::Vector.new([3,2])
      line = described_class.new(normal_vector: vect, constant_term: 5)
      expected = LinAlgRb::Vector.new([(5 / 3.0), 0])
      expect(line.basepoint).to eq expected
    end
  end

  describe '#to_s' do
    it do
      vect = LinAlgRb::Vector.new([-3,-2])
      line = described_class.new(normal_vector: vect, constant_term: 1)
      expect(line.to_s).to eq  "-3a - 2b = 1"
    end
  end

  describe '#parallel?' do
    it 'returns false' do
      line1 = described_class.new(
        normal_vector:  LinAlgRb::Vector.new([7.204, 3.182]),
        constant_term: 8.68
      )
      line2 = described_class.new(
        normal_vector:  LinAlgRb::Vector.new([8.172, 4.114]),
        constant_term: 9.883
      )
      expect(line1.parallel?(line2)).to eq false
    end
    it 'returns true' do
      line1 = described_class.new(
        normal_vector:  LinAlgRb::Vector.new([1.182, 5.562]),
        constant_term: 6.744
      )
      line2 = described_class.new(
        normal_vector:  LinAlgRb::Vector.new([1.773, 8.343]),
        constant_term: 9.525
      )
      expect(line1.parallel?(line2)).to eq true
    end
  end
  describe '#eql?' do
    it 'returns true' do
      line1 = described_class.new(
        normal_vector:  LinAlgRb::Vector.new([4.046, 2.836]),
        constant_term: 1.21
      )
      line2 = described_class.new(
        normal_vector:  LinAlgRb::Vector.new([10.115, 7.09]),
        constant_term: 3.025
      )
      expect(line1.eql?(line2)).to eq true
    end
    it 'returns false' do
      line1 = described_class.new(
        normal_vector:  LinAlgRb::Vector.new([1.182, 5.562]),
        constant_term: 6.744
      )
      line2 = described_class.new(
        normal_vector:  LinAlgRb::Vector.new([1.773, 8.343]),
        constant_term: 9.525
      )
      expect(line1.eql?(line2)).to eq false
    end
  end
  describe '#intersect' do
    it 'returns true' do
      line1 = described_class.new(
        normal_vector:  LinAlgRb::Vector.new([7.204, 3.182]),
        constant_term: 8.68
      )
      line2 = described_class.new(
        normal_vector:  LinAlgRb::Vector.new([8.172, 4.114]),
        constant_term: 9.883
      )
      result = line1.intersect(line2).coordinates.map { |c| c.round(3) }

      expect(result).to eq [1.173, 0.073]
    end
  end
end
