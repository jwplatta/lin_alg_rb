module LinAlgRb
  class NoNoneZeroElements < StandardError
    def initialize
      super("No non-zero elements.")
    end
  end

  class Line
    # NOTE: the normal vector provides the coefficients for the standard
    # form of the line, i.e. Ax + By = k. The normal vector is used instead
    # of the direction vector because the normal vector is easier to
    # generalize to higher dimensions.
    def initialize(normal_vector:, constant_term: 0)
      @dimension = 2
      raise ArgumentError.new("The normal vector needs to be an instance of LinAlgRb::Vector") if normal_vector.class != LinAlgRb::Vector
      @normal_vector = normal_vector
      @constant_term = constant_term
      @basepoint = find_basepoint
    end

    attr_reader :dimension, :normal_vector, :constant_term, :basepoint

    def parallel?(other)
      raise ArgumentError.new("Must be instance of LinAlgRb::Line") if other.class != Line

      normal_vector.parallel?(other.normal_vector)
    end

    def eql?(other)
      self.==(other)
    end

    def ==(other)
      raise ArgumentError.new("Must be instance of LinAlgRb::Line") if other.class != Line

      if normal_vector.zero?
        if !other.normal_vector.zero?
          return false
        else
          return near_zero?(constant_term - other.constant_term)
        end
      elsif other.normal_vector.zero?
        return false
      end

      return false if !parallel?(other)

      (basepoint - other.basepoint).orthogonal?(normal_vector)
    end

    def intersect(other)
      a, b = normal_vector.coordinates
      k1 = constant_term

      c, d = other.normal_vector.coordinates
      k2 = other.constant_term

      x_numerator = d*k1 - b*k2
      y_numerator = -c*k1 + a*k2
      one_over_denominator = 1.0 / (a*d - b*c)

      (LinAlgRb::Vector.new([x_numerator, y_numerator]) * one_over_denominator)
    rescue ZeroDivisionError => e
      if eql?(other)
        self
      else
        e
      end
    end

    def to_s
      decimal_places = 3
      vars = ('a'..'z').to_a
      init_index = first_nonzero_element_index(normal_vector.coordinates)

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
      elm_idx = first_nonzero_element_index(normal_vector.coordinates)
      init_coef = normal_vector[elm_idx]

      ([0] * dimension).then do |basepoint_coord|
        basepoint_coord[elm_idx] = (constant_term / init_coef.to_f)
        LinAlgRb::Vector.new(basepoint_coord)
      end
    rescue NoNoneZeroElements
      @basepoint = nil
    end

    def first_nonzero_element_index(elements)
      elm = elements.find_index { |e| !near_zero?(e) }
      raise NoNoneZeroElements.new unless elm
      elm
    end

    private

    def near_zero?(numeric, tolerance: 1e-10)
      numeric.abs < tolerance
    end
  end
end
