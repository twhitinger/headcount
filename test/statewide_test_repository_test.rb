
require_relative '../lib/statewide_test_repository'
require_relative '../lib/math_helper'
require_relative 'test_helper'


class StatewideTestRepositoryTest < Minitest::Test

  def  test_statewide_test_repository_exists
    skip
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
      })
      str = str.find_by_name("ACADEMY 20")
    end

    def test_statewide_test_initializes_with_default
      str = StatewideTestRepository.new
      assert str
    end

    def test_find_by_name(location_name)
      tests[location_name.upcase]
      # returns either nil or an instance of StatewideTest having done a case insensitive search
    end
  end
