module LinAlgRb
  class PlanesNotSameDimension < StandardError
    def initialize
      super("All planes must be same dimension.")
    end
  end

  class LinSysNoSolution < StandardError
    def initialize
      super("The linear system has no solution.")
    end
  end

  class LinSysInfiniteSolutions < StandardError
    def initialize
      super("The linear system has infinitely many solutions.")
    end
  end

  class Parametrization
    def initialize(basepoint, direction_vectors)
      @basepoint = basepoint
      @direction_vectors = direction_vectors
      @dimension = basepoint.dimension
    end

    attr_reader :basepoint, :direction_vectors, :dimension

    def coordinates
      basepoint.coordinates
    end

    def ==(other)
      basepoint == other.basepoint and direction_vectors == other.direction_vectors
    end

    def to_s
      output = ''
      (0...dimension).each do |coord|
        output += "x#{coord + 1} = "
        unless basepoint[coord].round(3) == 0.0
          output += "#{basepoint[coord].round(3)}"
        end

        direction_vectors.each_with_index do |vector, idx|
          if vector[coord].round(3) != 0.0
            output += " + " unless output[-2..] == "= "
            output += "#{vector[coord].round(3)}(t#{idx + 1}) "
          else
            ""
          end
        end
        output += "\n"
      end
      output
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

    def solve
      # NOTE: returns
      #   1. Vector object if there is a unique solution
      #   2. No solution: raise LinSysNoSolution
      #   3. Infinite solutions: raise LinSysInfiniteSolutions

      # STEP: get rref
      rref = to_rref
      # STEP: check for contradiction
      raise LinSysNoSolution.new if rref.contradiction?
      # STEP: check for pivot variable count
      # raise LinSysInfiniteSolutions.new if rref.pivot_variable_cnt < rref.dimension
      # STEP: get solution coordinates and return new vector
      if rref.pivot_variable_cnt < rref.dimension
        parametrize(rref)
      else
        rref.planes.map(&:constant_term).select { |ct| ct != 0.0 }.then do |coordinates|
          LinAlgRb::Vector.new(*coordinates)
        end
      end
    end

    def parametrize(rref)
      pivot_indices = rref.first_nonzero_term_indices
      free_var_indices = (0...rref.dimension).to_a - rref.first_nonzero_term_indices

      direction_vectors = free_var_indices.map do |free_var_idx|
        vector_coord = [0] * rref.dimension
        vector_coord[free_var_idx] = 1

        rref.planes.each_with_index do |plane, idx|
          pivot_var = pivot_indices[idx]
          break if pivot_var < 0
          vector_coord[pivot_var] = -1 * plane.normal_vector[free_var_idx]
        end
        LinAlgRb::Vector.new(vector_coord)
      end

      basepoint_coords = [0] * rref.dimension

      rref.planes.each_with_index do |plane, idx|
        pivot_var = pivot_indices[idx]
        break if pivot_var < 0
        basepoint_coords[pivot_var] = plane.constant_term # unless
      end

      Parametrization.new(
        LinAlgRb::Vector.new(basepoint_coords),
        direction_vectors
      )
    end

    def pivot_variable_cnt
      first_nonzero_term_indices.count { |index| index >= 0 }
    end

    def contradiction?
      planes.each do |plane|
        plane.first_nonzero_element_index
      rescue NoNoneZeroElements
        return true if !near_zero?(plane.constant_term)
      end

      false
    end

    def to_rref
      tri = LinSys.new(planes: to_triangular_form.planes.map(&:clone))

      equation_cnt = tri.planes.count
      # for each Row in tri.planes.reverse
      (0...equation_cnt).reverse_each do |eq_idx|
        row = tri[eq_idx]
        #   if no non-zero coef in Row
        #     go to next row
        #   index_first_non_zero_coef in Row
        term_idx = row.first_nonzero_element_index
        #   scale Row to make Coef at index_first_non_zero_coef be equal to 1
        scaled_row = tri[eq_idx] = tri.mult_coef_and_row((1 / row[term_idx].to_f), eq_idx)
        coef = scaled_row[term_idx]
        #   clear all terms with Coef in rows above Row (or after row if you reverse the array)
        (0...eq_idx).reverse_each do |next_eq_idx|
          next_eq_coef = tri[next_eq_idx].normal_vector[term_idx]

          unless next_eq_coef.zero?
            multiple = if (coef.positive? and next_eq_coef.negative?) or (coef.negative? and next_eq_coef.positive?)
              (next_eq_coef.abs / coef.abs.to_f)
            else
              -(next_eq_coef.abs / coef.abs.to_f)
            end

            tri[next_eq_idx] = tri.add_mult_times_row_to_row(multiple, eq_idx, next_eq_idx)
          end
        end
      rescue NoNoneZeroElements
        next
      end
      tri
    end

    def to_triangular_form
      # NOTE: swap with topmost row below current row
      # NOTE: Don't use mult_coef_and_row
      # NOTE: only add multiples of rows to rows underneath
      lin_sys_clone = LinSys.new(planes: planes.map(&:clone))
      equation_cnt = lin_sys_clone.planes.count
      term_cnt = lin_sys_clone.dimension
      term_idx = 0

      # STEP: for each equation E
      (0...equation_cnt).each do |eq_idx|
        equation = lin_sys_clone[eq_idx].normal_vector

        while term_idx < term_cnt
          # STEP: set coef at J index in E
          coef = equation[term_idx]
          # IF: coef is zero
          if coef.zero?
            # IF: there's a row beneath E with a nonzero coef at term idx
            first_nonzero_coef_idx = nil
            lin_sys_clone.planes.each_with_index do |plane, index|
              if index > eq_idx and !plane.normal_vector[term_idx].zero?
                first_nonzero_coef_idx = index
                break
              end
            end

            unless first_nonzero_coef_idx.nil?
              lin_sys_clone.swap_rows(eq_idx, first_nonzero_coef_idx)
              equation = lin_sys_clone[eq_idx].normal_vector # NOTE: need to lookup equation again before clearing the terms
            else
              term_idx += 1
            end
          end

          # STEP: clear all terms at term_idx below current equation
          (eq_idx+1...equation_cnt).each do |next_eq_idx|
            next_eq = lin_sys_clone[next_eq_idx].normal_vector

            unless next_eq[term_idx].zero?
              multiple = if (equation[term_idx].positive? and next_eq[term_idx].negative?) or (equation[term_idx].negative? and next_eq[term_idx].positive?)
                (next_eq[term_idx].abs / equation[term_idx].abs.to_f)
              else
                -(next_eq[term_idx].abs / equation[term_idx].abs.to_f)
              end
              lin_sys_clone[next_eq_idx] = lin_sys_clone.add_mult_times_row_to_row(
                multiple, eq_idx, next_eq_idx
              )
            end
          end

          term_idx += 1
          # STEP: go to next equation
          break
        end
      end

      lin_sys_clone
    end

    def swap_rows(row1_index, row2_index)
      planes[row1_index], planes[row2_index] = planes[row2_index], planes[row1_index]
    end

    def mult_coef_and_row(multiple, row_index)
      plane = planes[row_index]
      LinAlgRb::Plane.new(
        normal_vector: LinAlgRb::Vector.new(plane.normal_vector.coordinates.map { |c| c * multiple }),
        constant_term: plane.constant_term * multiple
      )
    end

    def add_mult_times_row_to_row(multiple, row1_index, row2_index)
      nv_1 = planes[row1_index].normal_vector
      k1 = planes[row1_index].constant_term
      nv_2 = planes[row2_index].normal_vector
      k2 = planes[row2_index].constant_term

      LinAlgRb::Plane.new(
        normal_vector: (nv_1 * multiple) + nv_2,
        constant_term: (k1 * multiple) + k2
      )
    end

    def first_nonzero_term_indices
      planes.map do |plane|
          plane.first_nonzero_element_index
      rescue LinAlgRb::NoNoneZeroElements
        -1
      end
    end

    def size
      planes.size
    end

    def [](index)
      planes[index]
    end

    def []=(index, plane)
      planes[index] = plane
    end

    def to_s
      planes_s = planes.map { |p| "\t#{p.to_s}" }.join("\n")
      "Linear System:\n#{planes_s}"
    end

    private

    def near_zero?(numeric, tolerance: 1e-10)
      numeric.abs < tolerance
    end
  end
end
