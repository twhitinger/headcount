require_relative '../lib/enrollment_repository'
require_relative '../lib/statewide_test'
require_relative '../lib/statewide_test_repository'

require_relative '../lib/math_helper'
require_relative 'test_helper'


class StatewideTestTest < Minitest::Test


  def test_proficient_by_grade_stored_in_hash
    
    str = StatewideTestRepository.new

    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
      }
      })
      e1 = {2008=>{:math=>0.697, :reading=>0.703, :writing=>0.501},
            2009=>{:math=>0.691, :reading=>0.726, :writing=>0.536},
            2010=>{:math=>0.706, :reading=>0.698, :writing=>0.504},
            2011=>{:math=>0.696, :reading=>0.728, :writing=>0.513},
            2012=>{:reading=>0.739, :math=>0.71, :writing=>0.525},
            2013=>{:math=>0.722, :reading=>0.732, :writing=>0.509},
            2014=>{:math=>0.715, :reading=>0.715, :writing=>0.51}}
      e2 = {2008=>{:math=>0.469, :reading=>0.703, :writing=>0.529},
            2009=>{:math=>0.499, :reading=>0.726, :writing=>0.528},
            2010=>{:math=>0.51, :reading=>0.679, :writing=>0.549},
            2011=>{:reading=>0.67, :math=>0.513, :writing=>0.543},
            2012=>{:math=>0.515, :writing=>0.548, :reading=>0.671},
            2013=>{:math=>0.514, :reading=>0.668, :writing=>0.557},
            2014=>{:math=>0.523, :reading=>0.663, :writing=>0.561}}

      statewide_test = str.find_by_name("Colorado")

      assert_equal e1, statewide_test.proficient_by_grade(3)
      assert_equal e2, statewide_test.proficient_by_grade(8)
      # assert_raise UnknownDataError, statewide_test.proficient_by_grade(7)
    end

    def test_proficient_by_grade_ethinic

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
        expected = {2011=>{:math=>0.709, :reading=>0.748, :writing=>0.656},
                    2012=>{:math=>0.719, :reading=>0.757, :writing=>0.658},
                    2013=>{:math=>0.732, :reading=>0.769, :writing=>0.682},
                    2014=>{:math=>0.734, :reading=>0.769, :writing=>0.684}}
        expected2 = {2011=>{:math=>0.658, :reading=>0.789, :writing=>0.663},
                     2012=>{:math=>0.661, :reading=>0.802, :writing=>0.644},
                     2013=>{:math=>0.669, :reading=>0.799, :writing=>0.655},
                     2014=>{:math=>0.671, :reading=>0.798, :writing=>0.647}}

        statewide_test = str.find_by_name("Colorado")

        assert_equal expected, statewide_test.proficient_by_race_or_ethnicity(:asian)
        assert_equal expected2, statewide_test.proficient_by_race_or_ethnicity(:white)
      end

      def test_proficient_by_grade_in_year
        
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

          statewide_test = str.find_by_name("Colorado")
          # statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
          assert_equal 0.697, statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
          assert_equal 0.671, statewide_test.proficient_for_subject_by_grade_in_year(:reading, 8, 2012)
        end

        def test_proficient_for_subject_by_race_in_year
          
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
              statewide_test = str.find_by_name("Colorado")

            assert_equal 0.719, statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
            assert_equal 0.789, statewide_test.proficient_for_subject_by_race_in_year(:reading, :white, 2011)
          end


        end
