module LinAlgRb
  class NoNonZeroElements < StandardError
    def initialize
      super("No non-zero elements.")
    end
  end

  class Plane
    def initialize(normal_vector:, constant_term: 0)
      raise ArgumentError.new("The normal vector needs to be an instance of LinAlgRb::Vector") if normal_vector.class != LinAlgRb::Vector
      @normal_vector = normal_vector
      @dimension = normal_vector.dimension
      @constant_term = constant_term
      @basepoint = find_basepoint
    end

    attr_reader :dimension, :normal_vector, :constant_term, :basepoint

    def parallel?(other)
      normal_vector.parallel?(other.normal_vector, to_decimal: 7)
    end

    def eql?(other)
      self.==(other)
    end

    def ==(other)
      (basepoint - other.basepoint).orthogonal?(normal_vector)
    end

    def to_s
      decimal_places = 3
      vars = ('a'..'z').to_a
      init_index = index_first_nonzero_element(normal_vector.coordinates)

      terms = (0...dimension).map do |index|
        coef = normal_vector[index].round(decimal_places)
        if coef != 0
          first_term = (index==init_index)
          if coef % 1 == 0.0
            coef = coef.to_i
          end

          output = ''

          if coef < 0
            output += '-'
          elsif coef > 0 and !first_term
            output += '+'
          end

          if !first_term
            output += ' '
          end

          if coef.abs != 1
            output += "#{coef.abs}"
          end

          "#{output}#{vars.shift}"
        end
      end.join(" ")

      "#{terms} = #{constant_term.round(decimal_places)}"
    end

    def find_basepoint
      elm_idx = index_first_nonzero_element(normal_vector.coordinates)
      init_coef = normal_vector[elm_idx]

      ([0] * dimension).then do |basepoint_coord|
        basepoint_coord[elm_idx] = (constant_term / init_coef.to_f)
        LinAlgRb::Vector.new(basepoint_coord)
      end
    rescue NoNonZeroElements
      @basepoint = nil
    end

    private

    def index_first_nonzero_element(elements)
      elm = elements.find_index { |e| !near_zero?(e) }
      raise NoNoneZeroElements.new unless elm
      elm
    end

    def near_zero?(numeric, tolerance: 1e-10)
      numeric.abs < tolerance
    end
  end
end
