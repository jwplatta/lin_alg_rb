require 'spec_helper'

describe LinAlgRb::LinSys do
  let(:planeA) do
    LinAlgRb::Plane.new(
      normal_vector: LinAlgRb::Vector.new(4,5,6)
    )
  end
  let(:planeB) do
    LinAlgRb::Plane.new(
      normal_vector: LinAlgRb::Vector.new(1,2,3)
    )
  end
  let(:planeC) do
    LinAlgRb::Plane.new(
      normal_vector: LinAlgRb::Vector.new(1,2,3,4)
    )
  end
  let(:planeD) do
    LinAlgRb::Plane.new(
      normal_vector: LinAlgRb::Vector.new(8,1,5)
    )
  end
  it 'raises when planes are different dimensions' do
    expect do
      described_class.new(planes: [planeA, planeC])
    end.to raise_error(LinAlgRb::PlanesNotSameDimension)
  end
  describe '#first_nonzero_term_indices' do
    it do
      expect(described_class.new(planes: [planeA, planeB]).first_nonzero_term_indices).to eq [0, 0]
    end
  end
  describe '#swap_rows' do
    it do
      lin_sys = described_class.new(planes: [planeA, planeB, planeD])
      lin_sys.swap_rows(0, 2)
      expect(lin_sys[0]).to eq planeD
      expect(lin_sys[2]).to eq planeA
    end
  end
  describe '#mult_coef_and_row' do
    it do
      lin_sys = described_class.new(planes: [planeA, planeB, planeD])
      expected_plane = LinAlgRb::Plane.new(
        normal_vector: LinAlgRb::Vector.new(40,50,60),
        constant_term: 0
      )
      result = lin_sys.mult_coef_and_row(10, 0)
      expect(result).to eq expected_plane
    end
  end
  describe '#add_mult_times_row_to_row' do
    it do
      lin_sys = described_class.new(planes: [planeA, planeB, planeD])
      expected_plane = LinAlgRb::Plane.new(
        normal_vector: LinAlgRb::Vector.new(5,7,9),
        constant_term: 0
      )
      result = lin_sys.add_mult_times_row_to_row(1, 0, 1)
      expect(result).to eq expected_plane
    end
  end
  describe '#to_triangular_form' do
    context 'system in triangular form' do
      it do
        plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,1,1),
          constant_term: 1
        )
        plane2 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(0,1,1),
          constant_term: 2
        )
        lin_sys = described_class.new(planes: [plane1, plane2]).to_triangular_form
        expect(lin_sys[0]).to eq plane1
        expect(lin_sys[1]).to eq plane2
      end
    end
    context 'two equation system' do
      it do
        plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,1,1),
          constant_term: 1
        )
        plane2 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,1,1),
          constant_term: 2
        )
        lin_sys = described_class.new(planes: [plane1, plane2]).to_triangular_form

        expected_plane2 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(0,0,0),
          constant_term: 1
        )
        expect(lin_sys[0]).to eq plane1
        expect(lin_sys[1]).to eq expected_plane2
      end
    end
    context 'system with redundant equation' do
      it do
        plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,1,1),
          constant_term: 1
        )
        plane2 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(0,1,0),
          constant_term: 2
        )
        plane3 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,1,-1),
          constant_term: 3
        )
        plane4 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,0,-2),
          constant_term: 2
        )
        lin_sys = described_class.new(planes: [plane1, plane2, plane3, plane4]).to_triangular_form
        expected_plane3 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(0,0,-2),
          constant_term: 2
        )
        expected_plane4 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::NullVector.new(dimension: 3)
        )
        expect(lin_sys[0]).to eq plane1
        expect(lin_sys[1]).to eq plane2
        expect(lin_sys[2]).to eq expected_plane3
        expect(lin_sys[3]).to eq expected_plane4
      end
    end
    context 'three equation system' do
      it do
        plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(0,1,1),
          constant_term: 1
        )
        plane2 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,-1,1),
          constant_term: 2
        )
        plane3 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,2,-5),
          constant_term: 3
        )
        lin_sys = described_class.new(planes: [plane1, plane2, plane3]).to_triangular_form

        expected_plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,-1,1),
          constant_term: 2
        )
        expected_plane2 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(0,1,1),
          constant_term: 1
        )
        expected_plane3 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(0,0,-9),
          constant_term: -2
        )
        expect(lin_sys[0]).to eq expected_plane1
        expect(lin_sys[1]).to eq expected_plane2
        expect(lin_sys[2]).to eq expected_plane3
      end
    end
  end

  describe '#to_rref' do
    context 'two planes' do
      it do
        plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,1,1),
          constant_term: 1
        )
        plane2 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(0,1,1),
          constant_term: 2
        )
        lin_sys = described_class.new(planes: [plane1, plane2]).to_rref

        expected_plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,0,0),
          constant_term: -1
        )
        expect(lin_sys[0]).to eq expected_plane1
        expect(lin_sys[1]).to eq plane2
      end
    end
    context 'parallel planes' do
      it do
        plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,1,1),
          constant_term: 1
        )
        plane2 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,1,1),
          constant_term: 2
        )
        lin_sys = described_class.new(planes: [plane1, plane2]).to_rref

        expected_plane2 = LinAlgRb::Plane.new(
          constant_term: 1
        )
        expect(lin_sys[0]).to eq plane1
        expect(lin_sys[1]).to eq expected_plane2
      end
    end
    context 'four planes' do
      it do
        plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,1,1),
          constant_term: 1
        )
        plane2 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(0,1,0),
          constant_term: 2
        )
        plane3 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,1,-1),
          constant_term: 3
        )
        plane4 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,0,-2),
          constant_term: 2
        )
        lin_sys = described_class.new(planes: [plane1, plane2, plane3, plane4]).to_rref

        expected_plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,0,0),
          constant_term: 0
        )
        expected_plane3 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(0,0,-2),
          constant_term: 2
        )

        expect(lin_sys[0]).to eq expected_plane1
        expect(lin_sys[1]).to eq plane2
        expect(lin_sys[2]).to eq expected_plane3
        expect(lin_sys[3]).to eq LinAlgRb::Plane.new
      end
    end
    context 'three planes' do
      it do
        plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(0,1,1),
          constant_term: 1
        )
        plane2 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,-1,1),
          constant_term: 2
        )
        plane3 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,2,-5),
          constant_term: 3
        )
        lin_sys = described_class.new(planes: [plane1, plane2, plane3]).to_rref

        expected_plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(1,0,0),
          constant_term: 23 / 9.0
        )
        expected_plane2 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(0,1,0),
          constant_term: 7 / 9.0
        )
        expected_plane3 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(0,0,1),
          constant_term: 2 / 9.0
        )

        expect(lin_sys[0]).to eq expected_plane1
        expect(lin_sys[1]).to eq expected_plane2
        expect(lin_sys[2]).to eq expected_plane3
      end
    end
  end

  describe '#solve' do
    context 'two planes' do
      it do
        plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(5.862,1.178,-10.366),
          constant_term: -8.15
        )
        plane2 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(-2.931,-0.589,5.183),
          constant_term: -4.075
        )
        expect do
          described_class.new(planes: [plane1, plane2]).solve
        end.to raise_error(LinAlgRb::LinSysNoSolution)
      end
    end
    context 'three planes' do
      it do
        plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(8.631,5.112,-1.816),
          constant_term: -5.113
        )
        plane2 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(4.315,11.132,-5.27),
          constant_term: -6.775
        )
        plane3 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(-2.158,3.01,-1.727),
          constant_term: -0.831
        )
        expect do
          described_class.new(planes: [plane1, plane2, plane3]).solve
        end.to raise_error(LinAlgRb::LinSysInfiniteSolutions)
      end
    end
    context 'four planes' do
      it do
        plane1 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(5.262,2.739,-9.878),
          constant_term: -3.441
        )
        plane2 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(5.111,6.358,7.638),
          constant_term: -2.152
        )
        plane3 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(2.016,-9.924,-1.367),
          constant_term: -9.278
        )
        plane4 = LinAlgRb::Plane.new(
          normal_vector: LinAlgRb::Vector.new(2.167,-13.543,-18.883),
          constant_term: -10.567
        )
        solution_vector = described_class.new(planes: [plane1, plane2, plane3, plane4]).solve

        expect(solution_vector.coordinates.map { |c| c.round(3) }).to eq [-1.177,0.707,-0.083]
      end
    end
  end
  describe '#[]=' do
    it do
      lin_sys = described_class.new(planes: [planeA, planeB, planeD])
      new_plane = LinAlgRb::Plane.new(
        normal_vector: LinAlgRb::Vector.new(7,6,2),
        constant_term: 0
      )
      lin_sys[1] = new_plane
      expect(lin_sys[1]).to eq new_plane
    end
  end
  describe '#to_s' do
    it do
      expected = "Linear System:\n\t4a + 5b + 6c = 0\n\ta + 2b + 3c = 0"
      expect(described_class.new(planes: [planeA, planeB]).to_s).to eq expected
    end
  end
end
