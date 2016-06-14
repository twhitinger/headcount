
require_relative '../lib/statewide_test_repository'
require_relative '../lib/math_helper'
require_relative 'test_helper'


class StatewideTestRepositoryTest < Minitest::Test

  def  test_statewide_test_repository_exists

    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
        # :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        # :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        # :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
      })
      expected = {:math=>{2008=>0.857, 2009=>0.824, 2010=>0.849, 2011=>0.819, 2012=>0.83, 2013=>0.8554, 2014=>0.8345},
      :reading=>{2008=>0.866, 2009=>0.862, 2010=>0.864, 2011=>0.867, 2012=>0.87, 2013=>0.85923, 2014=>0.83101},
      :writing=>{2008=>0.671, 2009=>0.706, 2010=>0.662, 2011=>0.678, 2012=>0.65517, 2014=>0.63942, 2013=>0.6687}}
      binding.pry
      str1 = str.find_by_name("ACADEMY 20")
      str2 = str.find_by_name("Muck the freeworld")

      assert_equal expected, str1
      assert_equal nil, str2
    end


      # def test_find_by_name(location_name)
      # end
    end
