module LinAlgRb
  class MatricesDifferentShapes < StandardError
    def initialize(arg=nil)
      if arg
        super("Matrices are not the same shape: #{arg}")
      else
        super("Matrices are not the same shape.")
      end
    end
  end

  class MatrixNotSquare < StandardError
    def initialize
      super("Matrix is not a square.")
    end
  end

  class MatrixHasNoInverse < StandardError
    def initialize
      super("Cannot invert matrix.")
    end
  end

  class Matrix
    class << self
      def identity(n)
        coordinates = []

        (0...n).each do |row_idx|
          row = []
          (0...n).each do |col_idx|
            if row_idx == col_idx
              row << 1
            else
              row << 0
            end
          end
          coordinates << row
        end

        new(coordinates)
      end
    end

    def initialize(args=nil)
      @coordinates = if args&.first.is_a? LinAlgRb::Vector
        unless args.find { |c| args[0].coordinates.count != c.coordinates.count }.nil?
          raise ArgumentError.new("Vectors must be the same size.")
        end

        args.map(&:coordinates)
      elsif args&.first.is_a? Array
        unless args.find { |c| c.count != args[0].count }.nil?
          raise ArgumentError.new("Elements must be the same size.")
        end

        args
      else
        [[]]
      end
    end

    attr_reader :coordinates

    def shape
      @shape ||= [coordinates.size, coordinates[0].size]
    end

    def multiply(other)
      self.*(other)
    end

    def *(other)
      if other.is_a? Numeric
        coordinates.map do |row|
          row.map { |col| col * other }
        end.then do |mult_coordinates|
          Matrix.new(mult_coordinates)
        end
      elsif other.is_a? Matrix
        raise ArgumentError.new("element-wise matrix multiplication not implemented")
      end
    end

    def matmul(other)
      if shape[1] != other.shape[0]
        raise MatricesDifferentShapes.new("Row size in first matrix not equal to column size in second matrix.")
      end
      col_size = other.shape[0]
      new_coordinates = []
      other_coordinates = other.coordinates

      new_coordinates = coordinates.map do |row|
        (0...other.shape[1]).to_a.map do |j_idx|
          (0...col_size).inject(0) do |sum, k_idx|
            sum + (row[k_idx] * other_coordinates[k_idx][j_idx])
          end
        end
      end

      Matrix.new(new_coordinates)
    end

    def add(other)
      self.+(other)
    end

    def +(other)
      raise MatricesDifferentShapes.new if shape != other.shape

      new_coordinates = []
      coordinates.each_with_index do |row, row_idx|
        column = []
        row.each_with_index do |col, col_idx|
          column << (col + other[row_idx][col_idx])
        end
        new_coordinates << column
      end

      Matrix.new(new_coordinates)
    end

    def subtract(other)
      self.-(other)
    end

    def -(other)
      raise MatricesDifferentShapes.new if shape != other.shape

      new_coordinates = []
      coordinates.each_with_index do |row, row_idx|
        column = []
        row.each_with_index do |col, col_idx|
          column << (col - other[row_idx][col_idx])
        end
        new_coordinates << column
      end

      Matrix.new(new_coordinates)
    end

    def transpose
      (0...shape[1]).to_a.map do |col_idx|
        # NOTE: #get_cols essentially turns the column into a row vector
        get_cols(col_idx)
      end.then do |rows|
        Matrix.new(rows)
      end
    end

    def diagonal
      cnt = (shape[0] < shape[1] ? shape[0] : shape[1])

      (0...cnt).map { |idx| coordinates[idx][idx] }
    end

    def trace
      diagonal.sum
    end

    def inverse
      raise MatrixNotSquare.new unless self.square?

      if shape[0] == 1
        Matrix.new([[1 / coordinates[0][0].to_f]])
      elsif shape[0] == 2
        a, b = coordinates[0]
        c, d = coordinates[1]

        raise MatrixHasNoInverse.new if (a * d) == (b * c)

        Matrix.new([[d, -b],[-c, a]]) * (1 / determinant.to_f)
      else
        raise StandardError.new("Cannot find inverse of matrices with dimension greater than 2.")
      end
    end

    def determinant
      raise MatrixNotSquare.new unless self.square?
      # NOTE: [[a, b], [c, d]] => ad - bc
      coordinates[0][0] * coordinates[1][1] - coordinates[0][1] * coordinates[1][0]
    end

    def square?
      shape[0] == shape[1]
    end

    def eql?(other)
      self.==(other)
    end

    def ==(other)
      coordinates == other.coordinates
    end

    def [](*args, axis: 0)
      if args.size == 1 and axis == 0
        get_rows(args.first)
      elsif args.size == 1 and axis == 1
        get_cols(args.first)
      elsif args.size == 2 and axis == 0
        row_indices, col_indices = args
        get_rows(row_indices).then do |subset|
          Matrix.new(subset).get_cols(col_indices)
        end
      elsif args.size == 2 and axis == 1
        col_indices, row_indices = args
        get_cols(col_indices).then do |subset|
          Matrix.new(subset).get_rows(row_indices)
        end
      else
        raise ArgumentError.new("Too many indices or wrong axis.")
      end
    end

    def get_cols(indices)
      if indices.is_a? Range
        first_col = indices.begin
        num_cols = indices.size
        coordinates.map { |row| row[first_col, num_cols] }
      elsif indices.is_a? Array
        coordinates.map do |row|
          row.select.with_index { |col, idx| indices.include? idx }
        end
      else
        coordinates.map { |row| row[indices] }
      end
    end

    def get_rows(indices)
      if indices.is_a? Range
        first_row = indices.begin
        num_rows = indices.size
        coordinates[first_row, num_rows]
      elsif indices.is_a? Array
        coordinates.select.with_index { |row, idx| indices.include? idx }
      else
        coordinates[indices]
      end
    end

    def to_s
      coordinates.map { |row| "#{row.join(' ')}" }.join("\n")
    end
  end
end
