module LinAlgRb
  class Matrix
    class << self
      def vector_to_matrix(vector)
        raise ArgumentError.new("#{vector} is not a LingAlgRb::Vector") unless vector.is_a? LinAlgRb::Vector
        new(vector.coordinates)
      end
    end

    def initialize(coordinates)
      @coordinates = [coordinates]
    end

    attr_reader :coordinates

    def [](*index)
      if index.size == 1
        index[0]
        coordinates[index[0]]
      else
        puts index.class
        nil
      end
    end

    def to_s
    end
  end
end
