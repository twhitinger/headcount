require_relative '../lib/math_helper'
require_relative '../lib/statewide_test_repository'

class StatewideTest
  attr_accessor :statewide_test, :class_data, :formatted_hash
  def initialize(data = {})
    @class_data = data
    @formatted_hash = {}
  end

  def proficient_by_grade(grade)
    # raise_unknown_data_error(grade)
    class_data[grade_hash(grade)]
  end

  def grade_hash(grade)
    grades = {3 => :third_grade, 8 => :eighth_grade}
    grades[grade]
  end

  def race_keys(race)
    array = [:asian, :black, :pacific_islander, :hispanic,
             :native_american, :two_or_more, :white]

    array.include?(race)
  end

  def proficient_by_race_or_ethnicity(race)
    raise_unknown_race_error(race)
 #    # collection = {:math => math}
 #      # :reading => scores[1][race], :writing => info[1][race]
 #    # symbol = [:math, :reading, :writing]
 #    # symbol.each do |symbol|
 #  math = class_data.reduce({}) do |result, obj|
 #    binding.pry
 #    if obj.first[:math]
 #      if result[obj[0]].nil?
 #        result[obj[0]] = {:math => obj[1][race]}
 #      elsif result[obj[0]]
 #
 #
 #    if result[obj[0]].nil?
 #     result[obj[0]] = {:math => obj[1][race]}
 #   end
 # end
 # collection = {:math => math}
 # binding.pry
 # end
    class_data[:math].each do |year|
      class_data[:reading].each do |scores|
        class_data[:writing].each do |info|
          collection[year[0]] = {:math => year[1][race],
            :reading => scores[1][race], :writing => info[1][race] }
        end
      end
    end
    collection
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    sub_arr = [:math, :reading, :writing]
    raise UnknownDataError unless sub_arr.include?(subject)
    class_data[grade_hash(grade)][year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    sub_arr = [:math, :reading, :writing]
    raise UnknownDataError unless sub_arr.include?(subject)
    class_data[subject][year][race]
  end

  def raise_unknown_race_error(race)
    raise UnknownRaceError unless race_keys(race)
  end

  def raise_unknown_data_error(grade)
    raise UnknownDataError unless class_data.values[0].class_data.keys.include?\
    (grade_hash(grade))
  end


end

class UnknownDataError < ArgumentError
end
class UnknownRaceError < ArgumentError
end
