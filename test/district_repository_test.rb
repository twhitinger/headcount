require_relative '../lib/district_repository'
require_relative '../lib/district'
require_relative 'test_helper'


class DistrictRepositoryTest < Minitest::Test

  def test_create_district_repository_class
    dr = DistrictRepository.new

    assert dr
  end

  def test_load_districts

    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district1 = dr.find_by_name("ACADEMY 20")
    district2 = dr.find_by_name("CALHAN RJ-1")
    district3 = dr.find_by_name("FUNHOUSE SCHOOL")


    assert_equal "ACADEMY 20", district1.name
    assert_equal "CALHAN RJ-1", district2.name
    refute district3
  end

  def test_find_by_name
    d1= District.new(name: "ACADEMY 20")
    d2= District.new(name: "ACADEMY 30")
    dr = DistrictRepository.new([d1,d2])

    district1 = dr.find_by_name("ACADEMY 20")
    district2 = dr.find_by_name("Academy 30")
    district3 = dr.find_by_name("Mile High University")

    assert_equal "ACADEMY 20", district1.name
    assert_equal "ACADEMY 30", district2.name
    refute district3

  end

  def test_find_all_matching
    d1 = District.new(name: "ACADEMY 20")
    d2 = District.new(name: "SPAM")
    d3 = District.new(name: "ACADEMY 30")
    dr = DistrictRepository.new([d1,d2,d3])
    r1 = dr.find_all_matching("aCademY")
    r2 = dr.find_all_matching("0")
    r3 = dr.find_all_matching("Clown School")

    assert_equal [d1,d3], r1
    assert_equal [d1,d3], r2
    assert_equal [], r3
  end

  def test_call_kindergarten_in_year_from_district
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    district = dr.find_by_name("ACADEMY 20")

    assert_equal 0.436, district.enrollment.kindergarten_participation_in_year(2010)
    assert_equal 0.489, district.enrollment.kindergarten_participation_in_year(2011)
    end


    def test_that_test_repository_connection
      dr = DistrictRepository.new
      dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv",
          :high_school_graduation => "./data/High school graduation rates.csv",
        },
        :statewide_testing => {
          :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
          :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
          :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
          :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
          :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
        }
      })

      district = dr.find_by_name("ACADEMY 20")
      expected = {:math=>0.857, :reading=>0.866, :writing=>0.671}
      expected2 = {:"all students"=>0.689, :asian=>0.818, :black=>0.424, :"hawaiian/pacific islander"=>0.571, :hispanic=>0.572, :"native american"=>0.571, :"two or more"=>0.689, :white=>0.713}

      assert_equal expected, district.statewide_test.class_data[:third_grade][2008]
      assert_equal expected2, district.statewide_test.class_data[:math][2012]
    end
  end
