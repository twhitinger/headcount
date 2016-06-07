require './lib/district_repository'
require './test/test_helper'


class DistrictRepositoryTest < Minitest::Test
  def test_create_district_repository_class
    dr = DistrictRepository.new
    assert dr
  end

  def test_method_load_data
    skip
    dr = DistrictRepository.new

    assert_equal dr.load_data(data), basic_domain_object_district
  end

end
