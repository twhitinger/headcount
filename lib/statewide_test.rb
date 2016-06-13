require_relative '../lib/math_helper'

class StatewideTest

  def initialize(data = [])
    @class_data = data
  end
# [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
  def proficient_by_grade(grade)
    raise_unknown_data_error(grade)
    @class_data[grade]
  end

  def proficient_by_race_or_ethnicity(race)

  end

  def third_hash
    {2009 => {:math => 0.854, :reading => 0.834, :writing => 0.645}}
  end

  def eight_hash
    {2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671}}
  end

  def raise_unknown_data_error(grade)
    raise UnknownDataError unless @class_data.keys.include?(grade)
  end
end

class UnknownDataError < ArgumentError
end
