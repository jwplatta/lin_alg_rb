module LinAlgRb
  class PlanesNotSameDimension < StandardError
    def initialize
      super("All planes must be same dimension.")
    end
  end

  class LinSys
    def initialize(planes: [])
      if planes.any?
        planes.each do |plane|
          raise PlanesNotSameDimension.new if plane.dimension != planes.first.dimension
        end
      end

      @planes = planes
      @dimension = planes.first.dimension
    end

    attr_reader :planes, :dimension

    def swap_rows(row1, row2)
    end

    def mult_coef_and_row(coef, row)
    end

    def add_mult_times_row_to_row(coef, row_to_add, row_to_be_added_to)
    end

    def size
      planes.size
    end

    def plane_at_index(index)
      planes[index]
    end
  end
end
