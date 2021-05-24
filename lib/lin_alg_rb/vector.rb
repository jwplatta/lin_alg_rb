module LinAlgRb
  class Vector
    def initialize(coordinates)
      raise TypeError.new('Coordinates must be an array') unless coordinates.is_a? Array
      raise ArgumentError.new('Coordinates cannot be empty') unless coordinates.count >= 2

      @coordinates = coordinates
      @dimension = coordinates.count
    end

    attr_reader :coordinates, :dimension

    def magnitude(norm_type=2)
      coordinates.inject(0) { |sum, v| sum + v**norm_type }
        .then { |summed_v| summed_v ** (1.0 / norm_type) }
    end

    def unit_vector(norm_type=2)
      return @unit_vector if defined? @unit_vector
      @unit_vector = normalize(norm_type)
    end

    def mult_scalar(other)
      raise TypeError.new('Other is not a scalar') unless other.is_a? Numeric

      self.class.new(coordinates.map { |c| c * other })
    end

    def add(other)
      self.+(other)
    end

    def +(other)
      raise TypeError.new('Other is not a vector') unless other.is_a? self.class
      raise ArgumentError.new('Dimensions must be equal') unless dimension == other.dimension

      new_coordinates = (0...dimension).map do |idx|
        coordinates[idx] + other.coordinates[idx]
      end

      self.class.new(new_coordinates)
    end

    def subtract(other)
      self.-(other)
    end

    def -(other)
      raise TypeError.new('Other is not a vector') unless other.is_a? self.class
      raise ArgumentError.new('Dimensions must be equal') unless dimension == other.dimension

      new_coordinates = (0...dimension).map do |idx|
        coordinates[idx] - other.coordinates[idx]
      end

      self.class.new(new_coordinates)
    end

    def to_s
      "Vector: {#{coordinates.join(',')}}"
    end

    def eql?(other)
      self.==(other)
    end

    def ==(other)
      coordinates == other.coordinates
    end

    private

    def normalize(norm_type=2)
      """
      1. Find magnitude
      2. Multiply the vector by the inverse of its magnitude
      """
      coordinates.map { |v| v * (1.0 / magnitude(norm_type)) }
    end
  end
end
