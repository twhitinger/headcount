require_relative '../lib/statewide_test_repository'
require_relative '../lib/math_helper'
require_relative 'test_helper'


class StatewideTestRepositoryTest < Minitest::Test

  def test_find_by_name_returns_location_data_or_nil
    str = StatewideTestRepository.new
    str.statewide_tests = {"ACADEMY 20" => {2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671}},
    "Colorado" => {2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706}}}

    str1 = str.find_by_name("ACADEMY 20")
    str2 = str.find_by_name("Muck the freeworld")
    str3 = str.find_by_name("Colorado")

    expected = {2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671}}
    expected2 = {2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706}}

    assert_equal expected, str1
    assert_equal nil, str2
    assert_equal expected2, str3
  end



  def  test_statewide_test_repository_exists
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
      }
    })
    expected = {:math=>0.857, :reading=>0.866, :writing=>0.671}
    expected2 = {:math=>0.697, :reading=>0.703, :writing=>0.501}
    str1 = str.find_by_name("ACADEMY 20").class_data[:third_grade][2008]
    str2 = str.find_by_name("Muck the freeworld")
    str3 = str.find_by_name("Colorado").class_data[:third_grade][2008]

    assert_equal expected, str1
    assert_equal nil, str2
    assert_equal expected2, str3
  end
end
