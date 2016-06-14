require_relative '../lib/math_helper'
require_relative '../lib/statewide_test_repository'

class StatewideTest
  attr_reader :class_data
  attr_accessor :statewide_test
  def initialize(data = {})
    @class_data = data
  end

  def proficient_by_grade(grade)
    raise_unknown_data_error(grade)
    @class_data["Colorado"].class_data[grade_hash(grade)]
  end

  def grade_hash(grade)
    grades = {3 => :third_grade, 8 => :eighth_grade}
    grades[grade]
  end

  def proficient_by_race_or_ethnicity(race)
    collection = {}
    data = @class_data["Colorado"].class_data
    data[:math].each do |year|
      data[:reading].each do |scores|
        data[:writing].each do |info|
          collection[year[0]] = {:math => year[1][race], :reading => scores[1][race], :writing => info[1][race] }
        end
      end
    end
    collection
  end



  def raise_unknown_data_error(grade)
    raise UnknownDataError unless class_data.values[0].class_data.keys.include?(grade_hash(grade))
  end
end

class UnknownDataError < ArgumentError
end
