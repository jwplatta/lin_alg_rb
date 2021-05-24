module LinAlgRb
  module Util
    def self.magnitude(vector, norm_type=2)
      raise ArgumentError.new('Must be a vector') unless vector.is_a? LinAlgRb::Vector
      raise ArgumentError.new('Norm type must be greater than zero.') unless norm_type > 0

      vector.coordinates.inject(0) { |sum, v| sum + v**norm_type }
        .then { |summed_v| summed_v ** (1.0 / norm_type) }
    end

    def self.unit_vector(vector, norm_type=2)
      inv_magnitude = (1.0 / LinAlgRb::Util.magnitude(vector, norm_type))
      LinAlgRb::Vector.new(vector.coordinates.map { |v| v *  inv_magnitude })
    end

    def self.is_unit_vector?(vector, norm_type=2)
      LinAlgRb::Util.magnitude(vector, norm_type) == 1.0
    end
  end
end