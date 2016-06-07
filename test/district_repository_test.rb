require './lib/district_repository'
require './lib/district'
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

  def test_load_districts
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
      })
      district = dr.find_by_name("ACADEMY 20")

      assert_equal "ACADEMY 20", district.name
    end

    def test_find_by_name
      d1= District.new(name: "ACADEMY 20")
      d2= District.new(name: "ACADEMY 30")
      dr = DistrictRepository.new([d1,d2])

      district = dr.find_by_name("ACADEMY 20")
        
      assert_equal "ACADEMY 20", district.name
    end

    def test_find_all_matching
      d1 = District.new(name: "ACADEMY 20")
      d2 = District.new(name: "SPAM")
      d3 = District.new(name: "ACADEMY 30")
      dr = DistrictRepository.new([d1,d2,d3])

      r1 = dr.find_all_matching("aCademY")
      r2 = dr.find_all_matching("0")
      assert_equal [d1,d3], r1
      assert_equal [d1,d3], r2
    end
  end
