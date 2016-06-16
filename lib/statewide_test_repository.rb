require_relative "statewide_test"
require_relative "math_helper"
require "csv"
require "pp"

class StatewideTestRepository
  attr_reader :tests
  attr_accessor :statewide_tests
  def initialize
    @statewide_tests = {}
  end

  def find_by_name(district_name)
    statewide_tests[district_name]
  end

  def load_data(file_tree)
    filepath = file_tree[:statewide_testing]
    filepath.each do |source, filename|
      years = CSV.readlines(filename, headers: true,
      header_converters: :symbol).map(&:to_h)
      scores_by_location = years.group_by do |row|
        row[:location]
      end
      combine_all_years = scores_by_location.each_with_object({})\
      do |(name, district_data), subject_data|
        single_district_data(name, district_data, subject_data)
      end
      test_data_merge(combine_all_years, source)
    end
  end

  def test_data_merge(combine_all_years, source)
    combine_all_years.each do |location_name, data|
      if find_by_name(location_name)
        find_by_name(location_name).class_data[source] = data
      else
        @statewide_tests[location_name] = StatewideTest.new({source => data})
      end
    end
  end

  def single_subject_data(year, data, district_data)
    one_subject_data = data.each_with_object({}) do |row, subject_data|
      subject_data[row[class_or_race(row)].downcase.to_sym]\
      = sanitize_data_to_na(row[:data])
    end
    district_data[year] = one_subject_data
  end

  def single_district_data(name, district_data, subject_data)
    grouped_data = group_by_year(district_data)
    subject_data[name] = grouped_data.each_with_object({})\
    do |(year, data), district_data|
      single_subject_data(year, data, district_data)
    end
  end

  def group_by_year(data)
    data.group_by { |row| row[:timeframe].to_i }
  end

  def class_or_race(row)
    if row.has_key?(:score)
      :score
    elsif row.has_key?(:race_ethnicity)
      :race_ethnicity
    end
  end

  def sanitize_data(input)
    input.to_s.gsub!(/[\s]+/,'')
    input = MathHelper.truncate_float(input.to_f) if String === input
    input
  end

  def sanitize_data_to_na(num)
    if sanitize_data(num) == 0 || sanitize_data(num).to_s.chars[0] == "N"
      "N/A"
    else
      sanitize_data(num)
    end
  end
end
