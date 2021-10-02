# frozen_string_literal: true

module LinAlgRb
  class Vector
    def initialize(coordinates)
      raise TypeError.new('Coordinates must be an array') unless coordinates.is_a? Array
      raise ArgumentError.new('Coordinates cannot be empty') unless coordinates.count >= 2

      @coordinates = coordinates
      @dimension = coordinates.count
    end

    attr_reader :coordinates, :dimension

    def dot_product(other)
      raise ArgumentError.new('Vectors must have the same dimension') unless other.dimension == dimension

      other_coordinates = other.coordinates

      (0...dimension).inject(0) do |sum, idx|
        sum + (coordinates[idx] * other_coordinates[idx])
      end
    end

    def magnitude(norm_type=2)
      coordinates.inject(0) { |sum, v| sum + v**norm_type }
        .then { |summed_v| summed_v ** (1.0 / norm_type) }
    end

    def unit_vector(norm_type=2)
      return @unit_vector if defined? @unit_vector
      @unit_vector = normalize(norm_type)
    end

    def is_unit_vector?(norm_type=2)
      magnitude(norm_type) == 1.0
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

    # Normalization:
    # 1. Find magnitude
    # 2. Multiply the vector by the inverse of its magnitude
    def normalize(norm_type=2)
      inv_magnitude = (1.0 / magnitude(norm_type))
      raise ZeroDivisionError if inv_magnitude == Float::INFINITY

      coordinates.map { |v| v * inv_magnitude }
    rescue ZeroDivisionError
      raise StandardError.new('The zero vector cannot be normalized.')
    end
  end
end
