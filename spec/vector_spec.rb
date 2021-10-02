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
    it 'returns a new vector with multiplied coordinates' do
      vect = described_class.new([1, 2])
      new_vect = vect.multiply(5)
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

      expect(vect.unit_vector.coordinates).to eq expected_unit_vect
    end

    it 'returns the correct unit vector for norm type 3' do
      coordinates = [3,4,5]
      norm_type = 3
      vect = described_class.new(coordinates)
      magnitude = vect.magnitude(norm_type)
      expected_unit_vect = coordinates.map { |v| v * (1.0 / magnitude) }

      expect(vect.unit_vector(norm_type).coordinates).to eq expected_unit_vect
    end

    it 'raises a StandardError for the zero vector' do
      vect = described_class.new([0, 0, 0])

      expect do
        vect.unit_vector
      end.to raise_error(StandardError, 'The zero vector cannot be normalized.')
    end
  end

  describe '.is_unit_vector?' do
    it 'returns true' do
      coordinates = [3, 4, 5]
      unit_vector = described_class.new(coordinates).unit_vector
      expect(unit_vector.is_unit_vector?).to be true
    end
    it 'returns false' do
      coordinates = [3, 4, 5]
      vect = described_class.new(coordinates)
      expect(vect.is_unit_vector?).to be false
    end
  end

  describe '#dot' do
    it 'returns the correct scalar value' do
      vect = described_class.new([1,2])
      other = described_class.new([3,4])

      expect(vect.dot(other)).to eq 11
    end
    it 'raises StandardError when vectors have different dimensions' do
      vect = described_class.new([1,2])
      other = described_class.new([3,4,5])

      expect do
        vect.dot(other)
      end.to raise_error(StandardError, 'Vectors must have the same dimension')
    end
  end

  describe '#inner' do
    # NOTE: same as #dot
    it 'returns the correct scalar value' do
      vect = described_class.new([1,2])
      other = described_class.new([3,4])

      expect(vect.inner(other)).to eq 11
    end
  end

  describe '#angle' do
    it 'returns correct angle in degress' do
      vect = described_class.new([3.183, -7.627])
      other = described_class.new([-2.668, 5.319])
      expect(vect.angle(other).round(3)).to eq 3.072
    end
    it 'returns correct angle in degress' do
      vect = described_class.new([7.35, 0.221, 5.188])
      other = described_class.new([2.751, 8.259, 3.985])
      result = vect.angle(other, degrees=true)
      expect(result.round(3)).to eq 60.276
    end
  end

  describe '#is_parallel?' do
    it 'returns false' do
      v1 = described_class.new([-2.029, 9.97, 4.172])
      v2 = described_class.new([-9.231, -6.639, -7.245])
      expect(v1.is_parallel?(v2)).to be false
    end

    it 'returns true' do
      v1 = described_class.new([-7.579, -7.88])
      v2 = described_class.new([22.737, 23.64])
      expect(v1.is_parallel?(v2)).to be true
    end
    context 'zero vector' do
      it 'returns true' do
        v1 = described_class.new([2.118, 4.827])
        v2 = described_class.new([0, 0])
        expect(v1.is_parallel?(v2)).to be true
      end
    end
  end

  describe '#is_orthogonal?' do
    it 'returns false' do
      v1 = described_class.new([-7.579, -7.88])
      v2 = described_class.new([22.737, 23.64])
      expect(v1.is_orthogonal?(v2)).to be false
    end

    it 'returns true' do
      v1 = described_class.new([-2.328, -7.284, -1.214])
      v2 = described_class.new([-1.821, 1.072, -2.94])
      expect(v1.is_orthogonal?(v2)).to be true
    end

    context 'zero vector' do
      it 'returns true' do
        v1 = described_class.new([2.118, 4.827])
        v2 = described_class.new([0, 0])
        expect(v1.is_orthogonal?(v2)).to be true
      end
    end
  end

  describe 'projecting vectors' do
    context '#parallel_component' do
      it do
        v1 = described_class.new([3.039, 1.879])
        basis = described_class.new([0.825, 2.036])
        result = v1.parallel_component(basis).coordinates.map { |c| c.round(3) }
        expect(result).to eq [1.083, 2.672]
      end
    end

    context '#orthogonal_component' do
      it do
        v1 = described_class.new([-9.88, -3.264, -8.159])
        basis = described_class.new([-2.155, -9.353, -9.473])
        result = v1.orthogonal_component(basis).coordinates.map { |c| c.round(3) }
        expect(result).to eq [-8.35, 3.376, -1.434]
      end
    end

    it 'finds both components' do
      v1 = described_class.new([3.009, -6.172, 3.692, -2.51])
      basis = described_class.new([6.404, -9.144, 2.759, 8.718])
      para_comp = v1.parallel_component(basis).coordinates.map { |c| c.round(3) }
      orth_comp = v1.orthogonal_component(basis).coordinates.map { |c| c.round(3) }
      expect(para_comp).to eq [1.969, -2.811, 0.848, 2.68]
      expect(orth_comp).to eq [1.04, -3.361, 2.844, -5.19]
    end
  end

  describe 'Elementwise multiplication' do
    it do
      v1 = described_class.new([1,2])
      v2 = described_class.new([3,4])
      expected = described_class.new([3, 8])
      expect(v1 * v2).to eq expected
    end
  end
end
