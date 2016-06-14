require_relative '../lib/enrollment_repository'
require_relative '../lib/statewide_test'
require_relative '../lib/statewide_test_repository'

require_relative '../lib/math_helper'
require_relative 'test_helper'


class StatewideTestTest < Minitest::Test


  def test_proficient_by_grade_stored_in_hash
    # skip
    str = StatewideTestRepository.new

    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
      }
      })
      e1 = {:math=>0.697, :reading=>0.703, :writing=>0.501}
      e2 = {:math=>0.499, :reading=>0.726, :writing=>0.528}

      statewide_test = StatewideTest.new(str.statewide_tests)

      assert_equal e1, statewide_test.proficient_by_grade(3)[2008]
      assert_equal e2, statewide_test.proficient_by_grade(8)[2009]
      # assert_raise UnknownDataError, statewide_test.proficient_by_grade(7)
    end

    def test_proficient_by_grade_ethinic
      # skip
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
        expected = {2011=>{:math=>0.709, :reading=>0.769, :writing=>0.684},
        2012=>{:math=>0.719, :reading=>0.769, :writing=>0.684},
        2013=>{:math=>0.732, :reading=>0.769, :writing=>0.684},
        2014=>{:math=>0.734, :reading=>0.769, :writing=>0.684}}
        expected2 = {2011=>{:math=>0.658, :reading=>0.798, :writing=>0.647},
        2012=>{:math=>0.661, :reading=>0.798, :writing=>0.647},
        2013=>{:math=>0.669, :reading=>0.798, :writing=>0.647},
        2014=>{:math=>0.671, :reading=>0.798, :writing=>0.647}}
        statewide_test = StatewideTest.new(str.statewide_tests)

        assert_equal expected, statewide_test.proficient_by_race_or_ethnicity(:asian)
        assert_equal expected2, statewide_test.proficient_by_race_or_ethnicity(:white)
      end

      def test_proficient_by_grade_in_year
        # skip

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
          statewide_test = StatewideTest.new(str.statewide_tests)
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
            statewide_test = StatewideTest.new(str.statewide_tests)

            assert_equal 0.719, statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
            assert_equal 0.789, statewide_test.proficient_for_subject_by_race_in_year(:reading, :white, 2011)
          end


        end
