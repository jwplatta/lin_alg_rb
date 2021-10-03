require 'spec_helper'

describe LinAlgRb::Plane do
  describe '#find_basepoint' do
    it do
      vect = LinAlgRb::Vector.new([3,2,1])
      line = described_class.new(normal_vector: vect, constant_term: 5)
      expected = LinAlgRb::Vector.new([(5 / 3.0), 0, 0])
      expect(line.basepoint).to eq expected
    end
  end

  describe '#to_s' do
    it do
      vect = LinAlgRb::Vector.new([-3,-2, 4])
      line = described_class.new(normal_vector: vect, constant_term: 1)
      expect(line.to_s).to eq  "-3a - 2b + 4c = 1"
    end
  end
  describe 'parallel and equal planes' do
    let(:plane3) do
      described_class.new(
        normal_vector: LinAlgRb::Vector.new([2.611, 5.528, 0.283]),
        constant_term: 4.6
      )
    end
    let(:plane4) do
      described_class.new(
        normal_vector: LinAlgRb::Vector.new([7.715, 8.306, 5.342]),
        constant_term: 3.76
      )
    end
    describe '#parallel?' do
      it 'returns true' do
        plane1 = described_class.new(
          normal_vector: LinAlgRb::Vector.new([-7.926, 8.625, -7.212]),
          constant_term: -7.952
        )
        plane2 = described_class.new(
          normal_vector: LinAlgRb::Vector.new([-2.642, 2.875, -2.404]),
          constant_term: -2.443
        )
        expect(plane1.parallel?(plane2)).to be true
      end
      it 'returns false' do
        expect(plane3.parallel?(plane4)).to be false
      end
    end
    describe '#eql?' do
      it 'returns true' do
        plane1 = described_class.new(
          normal_vector: LinAlgRb::Vector.new([-0.412, 3.806, 0.728]),
          constant_term: -3.46
        )
        plane2 = described_class.new(
          normal_vector: LinAlgRb::Vector.new([1.03, -9.515, -1.82]),
          constant_term: 8.65
        )
        expect(plane1.eql?(plane2)).to be true
      end
      it 'returns false' do
        expect(plane3.eql?(plane4)).to be false
      end
    end
  end
end
