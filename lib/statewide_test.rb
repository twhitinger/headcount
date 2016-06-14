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
    races = [:asian, :black, :pacific_islander, :hispanic,
      :native_american, :two_or_more, :white]
    raise_unknown_data_error(races.include?(race))
    @class_data[:math][race].map do |year, data|
      [year, {:math     => data,
        :reading  => class_data[:reading][race][year],
        :writing  => class_data[:writing][race][year]}]
      end.to_h
    end


      def raise_unknown_data_error(grade)
        raise UnknownDataError unless class_data.values[0].class_data.keys.include?(grade_hash(grade))
      end
    end
  
    class UnknownDataError < ArgumentError
    end
