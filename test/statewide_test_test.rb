require_relative '../lib/enrollment_repository'
require_relative '../lib/statewide_test'
require_relative '../lib/math_helper'
require_relative 'test_helper'


class StatewideTestTest < Minitest::Test


  def test_proficient_by_grade

    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
        # :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        # :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        # :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        # :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
      })

      assert_equal

    end


  end
