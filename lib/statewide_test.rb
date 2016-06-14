require_relative '../lib/math_helper'
require_relative '../lib/statewide_test_repository'

class StatewideTest
  attr_reader :class_data, :statewide_test
  def initialize(data = {})
    @class_data = data
  end
  # [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
  def proficient_by_grade(grade)
    raise_unknown_data_error(grade)
    @class_data[grade]
  end

  def proficient_by_race_or_ethnicity(race)

  end


  def raise_unknown_data_error(grade)
    raise UnknownDataError unless class_data.keys.include?(grade)
  end
end

class UnknownDataError < ArgumentError
end
