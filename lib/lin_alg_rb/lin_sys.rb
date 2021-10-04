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

    def first_nonzero_terms_indices
      planes.map do |plane|
        begin
          plane.first_nonzero_element_index
        rescue LinAlgRb::NoNonZeroElements
          -1
        end
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
