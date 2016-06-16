require_relative '../lib/math_helper'
require_relative '../lib/statewide_test_repository'

class StatewideTest
  attr_accessor :statewide_test, :class_data, :formatted_hash
  def initialize(data = {})
    @class_data = data
    @formatted_hash = {}
    @embedded_hash = {}
  end

  def proficient_by_grade(grade)
    raise UnknownDataError unless grade == 3 || grade == 8
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
      class_data[:math].keys.each do |year|
        make_hash_entry(year, race)
        @formatted_hash[year] = @embedded_hash
      end
      @formatted_hash
    end

    def make_hash_entry(year, race)
      @embedded_hash = {}
      @embedded_hash[:math] = class_data[:math][year][race]
      @embedded_hash[:reading] = class_data[:reading][year][race]
      @embedded_hash[:writing] = class_data[:writing][year][race]
    end

    def proficient_for_subject_by_grade_in_year(subject, grade, year)
      sub_arr = [:math, :reading, :writing]

      raise UnknownDataError unless sub_arr.include?(subject)
      class_data[grade_hash(grade)][year][subject]
    end

    def proficient_for_subject_by_race_in_year(subject, race, year)
      sub_arr = [:math, :reading, :writing]
      raise UnknownDataError unless race_keys(race)
      raise UnknownDataError unless sub_arr.include?(subject)
      class_data[subject][year][race]
    end

    def raise_unknown_race_error(race)
      raise UnknownRaceError unless race_keys(race)
    end

    def raise_unknown_data_error(grade)
      raise UnknownDataError unless grade_hash(grade)
    end
  end

  class UnknownDataError < ArgumentError
  end
  class UnknownRaceError < ArgumentError
  end
