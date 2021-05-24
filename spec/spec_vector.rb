require 'spec_helper'

describe LinAlgRb::Vector do
  describe '.initialize' do
    it 'sets initial attributes' do
      vector_as_list = [1, 2]
      vect = described_class.new(vector_as_list)

      expect(vect.coordinates).to eq([1, 2])
      expect(vect.dimension).to eq(2)
    end

    it 'raises TypeError when coordinates are not passed as an Array' do
      expect do
        described_class.new(1)
      end.to raise_error(TypeError, 'Coordinates must be an array')
    end

    it 'raises ArgumentError when size of coordinates is not two or more' do
      expect do
        described_class.new([1])
      end.to raise_error(ArgumentError, 'Coordinates cannot be empty')
    end
  end

  describe '#to_s' do
    it 'returns a string representation of the vector' do
      vector_as_list = [1, 2]
      vect = described_class.new(vector_as_list)

      expect(vect.to_s).to eq('Vector: {1,2}')
    end
  end

  describe '#==' do
    it 'returns true when other is equal' do
      vect = described_class.new([1,2])
      other = described_class.new([1,2])

      expect(vect == other).to be true
    end
    it 'returns false when other is not equal' do
      vect = described_class.new([1,2])
      other = described_class.new([3,4])

      expect(vect == other).to be false
    end
  end

  describe 'vector addition' do
    it 'raises TypeError when other is not a Vector' do
      vect = described_class.new([1,2])
      other = [3,4]

      expect do
        vect + other
      end.to raise_error(TypeError, 'Other is not a vector')
    end

    it 'raises ArgumentError when other does not have the same dimension' do
      vect = described_class.new([1,2])
      other = described_class.new([3,4,5])

      expect do
        vect + other
      end.to raise_error(ArgumentError, 'Dimensions must be equal')
    end

    it 'returns a new vector with the summed coordinates' do
      vect = described_class.new([1,2])
      other = described_class.new([3,4])

      new_vect = vect + other

      expect(new_vect.coordinates).to eq([4,6])
      expect(new_vect.dimension).to eq(vect.dimension)
    end
  end

  describe 'vector subtraction' do
    it 'raises TypeError when other is not a Vector' do
      vect = described_class.new([1,2])
      other = [3,4]

      expect do
        vect - other
      end.to raise_error(TypeError, 'Other is not a vector')
    end

    it 'raises ArgumentError when other does not have the same dimension' do
      vect = described_class.new([1,2])
      other = described_class.new([3,4,5])

      expect do
        vect - other
      end.to raise_error(ArgumentError, 'Dimensions must be equal')
    end

    it 'returns a new vector with the subtracted coordinates' do
      vect = described_class.new([1,2])
      other = described_class.new([3,4])

      new_vect = vect - other

      expect(new_vect.coordinates).to eq([-2,-2])
      expect(new_vect.dimension).to eq(vect.dimension)
    end
  end

  describe 'vector scalar multiplication' do
    it 'raises TypeError when other is not a scalar' do
      vect = described_class.new([1, 2])
      expect do
        vect.mult_scalar([1,2])
      end.to raise_error(TypeError, 'Other is not a scalar')
    end
    it 'returns a new vector with multiplied coordinates' do
      vect = described_class.new([1, 2])
      new_vect = vect.mult_scalar(5)

      expect(new_vect.dimension).to eq(vect.dimension)
      expect(new_vect.coordinates).to eq([5, 10])
    end
  end

  describe 'vector magnitude' do
    it 'returns the correct norm for default norm type' do
      vect = described_class.new([3,4,5])
      expect(vect.magnitude).to eq Math.sqrt(50)
    end

    it 'returns the correct norm for norm type 3' do
      vect = described_class.new([2, 2])
      expect(vect.magnitude(3)).to eq Math.cbrt(16)
    end
  end

  describe 'vector normalization' do
    it 'returns the correct unit vector for default norm type' do
      coordinates = [3,4,5]
      vect = described_class.new(coordinates)
      expected_unit_vect = coordinates.map { |v| v * (1.0 / Math.sqrt(50)) }

      expect(vect.unit_vector).to eq expected_unit_vect
    end

    it 'returns the correct unit vector for norm type 3' do
      coordinates = [3,4,5]
      norm_type = 3
      vect = described_class.new(coordinates)
      magnitude = vect.magnitude(norm_type)
      expected_unit_vect = coordinates.map { |v| v * (1.0 / magnitude) }

      expect(vect.unit_vector(norm_type)).to eq expected_unit_vect
    end
  end

  describe '.is_unit_vector?' do
    it 'returns true' do
      coordinates = [3, 4, 5]
      vect = LinAlgRb::Vector.new(coordinates)
      unit_vector = LinAlgRb::Util.unit_vector(vect)

      expect(unit_vector.is_unit_vector?).to be true
    end

    it 'returns false' do
      coordinates = [3, 4, 5]
      vect = LinAlgRb::Vector.new(coordinates)

      expect(vect.is_unit_vector?).to be false
    end
  end
end
