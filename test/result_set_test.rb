require_relative 'test_helper'
require_relative '../lib/result_set'

class ResultSetTest < Minitest::Test

  def test_matching_districts_statewide_average_intialize_correctly

    rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)
    e1 = {:free_and_reduced_price_lunch_rate=>0.5, :children_in_poverty_rate=>0.25, :high_school_graduation_rate=>0.75}
    e2 = {:free_and_reduced_price_lunch_rate=>0.3, :children_in_poverty_rate=>0.2, :high_school_graduation_rate=>0.6}
    assert_equal e1, rs.matching_districts[0].econ_data
    assert_equal e2, rs.statewide_average.econ_data
  end

  # def test_result_set_responds_to_methods_to_access_matching_districts
  #   rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)
  #   assert_equal 0.5, rs.matching_districts[0].free_and_reduced_price_lunch_rate
  #   assert_equal 0.2, rs.statewide_average.children_in_poverty_rate
  # end

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
