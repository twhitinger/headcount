require_relative '../lib/enrollment_repository'
require_relative '../lib/statewide_test'
require_relative '../lib/math_helper'
require_relative 'test_helper'


class StatewideTestTest < Minitest::Test

    def test_proficient_by_grade_method
      statewide_test = StatewideTest.new
      third_hash = {2009 => {:math => 0.854, :reading => 0.834, :writing => 0.645}}
      eight_hash = {2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671}}

      # [3, 8] choose from each instance variable, return a hash with key year/timeframe value is a hash of each
      # subject that corresponds to the year/timeframe
      # {2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671}}
      assert_equal ({2009 => {:math => 0.854, :reading => 0.834, :writing => 0.645}}), statewide_test.proficient_by_grade(3)
      assert_equal ({2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671}}), statewide_test.proficient_by_grade(8)
      skip
      assert_raise UnknownDataError, statewide_test.proficient_by_grade(9)

        #
        # => { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
        #      2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
        #      2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
        #      2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
        #      2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
        #      2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
        #      2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
        #    }

# need year, subject, and value. grouped by year
      end




      def test_array_returns_hash_formatted_properly


      end
end
