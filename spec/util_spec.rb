require 'spec_helper'

describe LinAlgRb::Util do
  describe '.magnitude' do
    it 'returns correct magnitude' do
      vect = LinAlgRb::Vector.new([3,4,5])
      mag = LinAlgRb::Util.magnitude(vect)

      expect(mag).to eq Math.sqrt(50)
    end
  end

  describe '.unit_vector' do
    it 'returns the unit vector for a given vector' do
      coordinates = [3, 4, 5]
      vect = LinAlgRb::Vector.new(coordinates)
      unit_vector = LinAlgRb::Util.unit_vector(vect)

      unit_vect_coordinates = coordinates.map { |v| (1.0 / Math.sqrt(50)) * v }

      expect(unit_vector.coordinates).to eq(unit_vect_coordinates)
    end
  end

  describe '.is_unit_vector?' do
    it 'returns true' do
      coordinates = [3, 4, 5]
      vect = LinAlgRb::Vector.new(coordinates)
      unit_vector = LinAlgRb::Util.unit_vector(vect)

      expect(LinAlgRb::Util.is_unit_vector?(unit_vector)).to be true
    end

    it 'returns false' do
      coordinates = [3, 4, 5]
      vect = LinAlgRb::Vector.new(coordinates)

      expect(LinAlgRb::Util.is_unit_vector?(vect)).to be false
    end
  end
end
