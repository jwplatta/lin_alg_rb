require 'spec_helper'

describe LinAlgRb::LinSys do
  it 'raises when planes are different dimensions' do
    plane_1 = LinAlgRb::Plane.new(
      normal_vector: LinAlgRb::Vector.new(1,2,3,4)
    )
    plane_2 = LinAlgRb::Plane.new(
      normal_vector: LinAlgRb::Vector.new(1,2,3)
    )

    expect do
      described_class.new(planes: [plane_1, plane_2])
    end.to raise_error(LinAlgRb::PlanesNotSameDimension)
  end
end
