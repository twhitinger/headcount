require_relative 'test_helper'
require_relative '../lib/result_entry'
require_relative '../lib/result_set'

class ResultEntryTest < Minitest::Test

  def test_result_set_responds_to_methods_to_access_matching_districts
    rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)

    assert_equal 0.5, rs.matching_districts[0].free_and_reduced_price_lunch_rate
    assert_equal 0.2, rs.statewide_average.children_in_poverty_rate
    assert_equal 0.6, rs.statewide_average.high_school_graduation_rate
    assert_nil rs.statewide_average.median_household_income
  end

  def r1
    ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75})
  end

  def r2
    ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
    children_in_poverty_rate: 0.2,
    high_school_graduation_rate: 0.6})
  end

end
