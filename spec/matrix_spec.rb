require 'spec_helper'

describe LinAlgRb::Matrix do
  describe '#initialize' do
    context 'empty coordinates' do
      it 'it returns an empty matrix' do
        matrix = described_class.new
        expect(matrix.coordinates).to eq [[]]
      end
    end
    context 'coordinates from vectors' do
      it 'raises when vectors are different sizes' do
        expect do
          described_class.new([LinAlgRb::Vector.new([1,2]), LinAlgRb::Vector.new([3,4,5])])
        end.to raise_error(ArgumentError)
      end
      it 'it returns correct coordinates' do
        matrix = described_class.new([LinAlgRb::Vector.new([1,2]), LinAlgRb::Vector.new([3,4])])
        expect(matrix.coordinates).to eq [[1, 2], [3, 4]]
      end
    end
    context 'coordinates from arrays' do
      it 'raises when vectors are different sizes' do
        expect do
          described_class.new([[1,2], [3,4,5]])
        end.to raise_error(ArgumentError)
      end
      it 'it returns correct coordinates' do
        matrix = described_class.new([[1,2], [3,4]])
        expect(matrix.coordinates).to eq [[1, 2], [3, 4]]
      end
    end
  end
  describe 'matrix equality' do
    it 'returns true' do
      matrix1 = described_class.new([[1,2,5], [3,4,7],[1,9,2]])
      matrix2 = described_class.new([[1,2,5], [3,4,7],[1,9,2]])
      expect(matrix1 == matrix2).to eq true
    end
    it 'returns false' do
      matrix1 = described_class.new([[1,2,5], [3,4,7],[1,9,2]])
      matrix2 = described_class.new([[1,2], [3,4],[1,9]])
      expect(matrix1 == matrix2).to eq false
    end
  end
  describe 'scalar multiplication' do
    it do
      matrix = described_class.new([[1,2,5], [3,4,7],[1,9,2]]) * 5
      expected_matrix = described_class.new([[5, 10, 25], [15, 20, 35], [5, 45, 10]])
      expect(matrix).to eq expected_matrix
    end
  end
  describe 'matrix addition' do
    it 'raises error when different shapes' do
      matrix1 = described_class.new([[1,2,5], [3,4,7],[1,9,2]])
      matrix2 = described_class.new([[3,3], [4,4],[2,2]])
      expect do
        matrix1 + matrix2
      end.to raise_error(LinAlgRb::MatricesDifferentShapes)
    end
    it do
      matrix1 = described_class.new([[1,2,5], [3,4,7],[1,9,2]])
      matrix2 = described_class.new([[3,3,3], [4,4,4],[2,2,2]])
      expected_matrix = described_class.new([[4,5,8], [7,8,11],[3,11,4]])
      expect(matrix1 + matrix2).to eq expected_matrix
    end
  end
  describe 'matrix subtraction' do
    it 'raises error when different shapes' do
      matrix1 = described_class.new([[1,2,5], [3,4,7],[1,9,2]])
      matrix2 = described_class.new([[3,3], [4,4],[2,2]])
      expect do
        matrix1 - matrix2
      end.to raise_error(LinAlgRb::MatricesDifferentShapes)
    end
    it do
      matrix1 = described_class.new([[1,2,5], [3,4,7],[1,9,2]])
      matrix2 = described_class.new([[3,3,3], [4,4,4],[2,2,2]])
      expected_matrix = described_class.new([[-2,-1,2], [-1,0,3],[-1,7,0]])
      expect(matrix1 - matrix2).to eq expected_matrix
    end
  end
  describe '#matmul' do
    it do
      matrix1 = described_class.new([[17,25,6,2],[6,1,97,4],[80,8,54,15]])
      matrix2 = described_class.new([[3,14,1,7,42,5],[32,11,2,4,18,17],[19,81,4,8,5,10],[27,2,3,6,7,3]])
      expected_matrix = described_class.new([[1019,1003,97,279,1208,576],[2001,7960,408,846,783,1029],[1927,5612,357,1114,3879,1121]])

      expect(matrix1.matmul(matrix2)).to eq expected_matrix
    end
  end
  describe '#transpose' do
    it do
      matrix = described_class.new([[5,4,1,7], [2,1,3,5]])
      expected_matrix = described_class.new([[5,2],[4,1],[1,3],[7,5]])
      expect(matrix.transpose).to eq expected_matrix
    end
  end
  describe '#diagonal' do
    it do
      matrix = described_class.new([[5,4,1,7], [2,1,3,5]])
      expect(matrix.diagonal).to eq [5, 1]
    end
  end
  describe '#trace' do
    it do
      matrix = described_class.new([[5,4,1,7], [2,1,3,5]])
      expect(matrix.trace).to eq 6
    end
  end
  describe '#inverse' do
    context 'dimension 1' do
      it do
        matrix = described_class.new([[100]])
        expected_matrix = described_class.new([[1 / 100.0]])
        expect(matrix.inverse).to eq expected_matrix
      end
    end
    context 'dimension 2' do
      it do
        matrix = described_class.new([[4, 5], [7, 1]])
        expected_matrix = described_class.new([[-0.03225806451612903, 0.16129032258064516], [0.22580645161290322, -0.12903225806451613]])
        expect(matrix.inverse).to eq expected_matrix
      end
    end
    context 'no inverse' do
      it 'it raises' do
        expect do
          described_class.new([[4, 2], [14, 7]]).inverse
        end.to raise_error(LinAlgRb::MatrixHasNoInverse)
      end
    end
  end
  describe '.identity' do
    it 'creates identity matrix for n equals 1' do
      matrix = LinAlgRb::Matrix.identity(1)
      expected_matrix = described_class.new([[1]])
      expect(matrix).to eq expected_matrix
    end
    it 'creates identity matrix for n equals 2' do
      matrix = LinAlgRb::Matrix.identity(2)
      expected_matrix = described_class.new([[1,0], [0,1]])
      expect(matrix).to eq expected_matrix
    end
    it 'creates identity matrix for n equals 4' do
      matrix = LinAlgRb::Matrix.identity(4)
      expected_matrix = described_class.new([[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]])
      expect(matrix).to eq expected_matrix
    end
  end
  describe '#to_s' do
    it do
      matrix = described_class.new([[1,2,5], [3,4,7],[1,9,2]])
      expect(matrix.to_s).to eq "1 2 5\n3 4 7\n1 9 2"
    end
  end
  describe '#[]' do
    context 'get row' do
      it do
        matrix = described_class.new([[17,25,6,2],[6,1,97,4],[80,8,54,15]])
        expect(matrix[1]).to eq [6,1,97,4]
      end
    end
    context 'get range of rows' do
      it do
        matrix = described_class.new([[17,25,6,2],[6,1,97,4],[80,8,54,15]])
        expect(matrix[(1..2)]).to eq [[6,1,97,4],[80,8,54,15]]
      end
    end
    context 'get list of rows' do
      it do
        matrix = described_class.new([[17,25,6,2],[6,1,97,4],[80,8,54,15]])
        expect(matrix[[0,2]]).to eq [[17,25,6,2],[80,8,54,15]]
      end
    end
    context 'get column' do
      it do
        matrix = described_class.new([[17,25,6,2],[6,1,97,4],[80,8,54,15]])
        expect(matrix[1, axis: 1]).to eq [25,1,8]
      end
    end
    context 'get range of columns' do
      it do
        matrix = described_class.new([[17,25,6,2],[6,1,97,4],[80,8,54,15]])
        expect(matrix[(1..2), axis: 1]).to eq [[25,6],[1,97],[8,54]]
      end
    end
    context 'get list of columns' do
      it do
        matrix = described_class.new([[17,25,6,2],[6,1,97,4],[80,8,54,15]])
        expect(matrix[[1,3], axis: 1]).to eq [[25,2],[1,4],[8,15]]
      end
    end
    context 'get subset' do
      it do
        matrix = described_class.new([[17,25,6,2],[6,1,97,4],[80,8,54,15]])
        expect(matrix[[1,2], (1..2)]).to eq [[1,97],[8,54]]
      end
    end
  end
end
