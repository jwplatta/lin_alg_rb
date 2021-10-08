# frozen_string_literal: true

require 'singleton'

module LinAlgRb
  class Vector
    def initialize(*coordinates)
      coordinates = coordinates.flatten
      raise TypeError.new('Coordinates must be an array') unless coordinates.is_a? Array
      raise ArgumentError.new('Coordinates cannot be empty') unless coordinates.count >= 2
      @coordinates = coordinates
      @dimension = coordinates.count
    end

    attr_reader :coordinates, :dimension

    def inner(other)
      dot(other)
    end

    def dot(other)
      # NOTE: For example, the dot product of [9, 7, 5] and [2, 3, 4] is 9*2+7*3 +5*4 = 59.
      raise ArgumentError.new('Vectors must have the same dimension') if other.dimension != dimension

      other_coordinates = other.coordinates

      (0...dimension).inject(0) do |sum, idx|
        sum + (coordinates[idx] * other_coordinates[idx])
      end
    end

    def cross(other)
      raise ArgumentError.new("Vectors must have dimension 3.") if dimension != 3 or other.dimension != 3

      x1, y1, z1 = coordinates
      x2, y2, z2 = other.coordinates

      Vector.new([
        y1 * z2 - y2 * z1,
        -(x1 * z2 - x2 * z1),
        x1 * y2 - x2 * y1
      ])
    end

    def magnitude(norm_type=2)
      coordinates.inject(0) { |sum, v| sum + v**norm_type }
        .then { |summed_v| summed_v ** (1.0 / norm_type) }
    end

    def unit_vector(norm_type=2)
      Vector.new(normalize(norm_type))
    end

    def unit_vector?(norm_type=2)
      magnitude(norm_type) == 1.0
    end

    def zero?(tolerance=1e-10)
      magnitude < tolerance
    end

    def multiply(other)
      self.*(other)
    end

    def *(other)
      if other.is_a? Numeric
        Vector.new(coordinates.map { |c| c * other })
      elsif other.is_a? Vector
        raise ArgumentError.new('Vectors must have the same dimension') if other.dimension != dimension
        # NOTE: Hadamard product or element-wise product
        Vector.new(
          coordinates.enum_for(:each_with_index).map do |c, index|
            c * other.coordinates[index]
          end
        )
      end
    end

    def add(other)
      self.+(other)
    end

    def +(other)
      raise TypeError.new('Other is not a vector') unless other.is_a? Vector
      raise ArgumentError.new('Dimensions must be equal') unless dimension == other.dimension

      new_coordinates = (0...dimension).map do |idx|
        coordinates[idx] + other.coordinates[idx]
      end

      Vector.new(new_coordinates)
    end

    def subtract(other)
      self.-(other)
    end

    def -(other)
      raise TypeError.new('Other is not a vector') unless other.is_a? Vector
      raise ArgumentError.new('Dimensions must be equal') unless dimension == other.dimension

      new_coordinates = (0...dimension).map do |idx|
        coordinates[idx] - other.coordinates[idx]
      end

      Vector.new(new_coordinates)
    end

    def [](index)
      coordinates[index]
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

    # NOTE: defaults to radians
    def angle(other, degrees=false)
      unit_vector.dot(other.unit_vector).then do |dot_product|
        if dot_product < -1.0 or dot_product > 1.0
          dot_product = dot_product.round(2)
        end

        if degrees
          radians_to_degrees(Math.acos(dot_product))
        else
          Math.acos(dot_product)
        end
      end
    end

    def parallel?(other, to_decimal: 10)
      self.zero? \
        or other.zero? \
        or angle(other).round(to_decimal) == 0.0 \
        or angle(other) == Math::PI
    end

    def orthogonal?(other, tolerance=1e-10)
      dot(other).abs < tolerance
    end

    def parallel_component(other)
      other.unit_vector * dot(other.unit_vector)
    end

    def orthogonal_component(other)
      parallel = parallel_component(other)
      self - parallel
    end

    private

    def radians_to_degrees(radians)
      Util.radians_to_degrees(radians)
    end

    # Normalization:
    # 1. Find magnitude
    # 2. Multiply the vector by the inverse of its magnitude
    def normalize(norm_type)
      inv_magnitude = (1.0 / magnitude(norm_type))
      raise ZeroDivisionError if inv_magnitude == Float::INFINITY

      coordinates.map { |v| v * inv_magnitude }
    rescue ZeroDivisionError
      raise StandardError.new('The zero vector cannot be normalized.')
    end
  end

  class NullVector < Vector
    def initialize(dimension: 2)
      super([0] * dimension)
    end

    def magnitude; 0 end
    def unit_vector?; false end
    def zero?; false end
    def eql?; false end

    # NOTE: Zero vector is parallel and orthogonal to all other vectors.
    # And it is orthogonal to itself.
    def parallel?; false end
    def orthogonal?; false end

    def unit_vector
      raise StandardError.new("Null vector has no normalization.")
    end
  end
end
