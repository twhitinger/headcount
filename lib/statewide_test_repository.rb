require_relative "statewide_test"
require "csv"
require "pp"

class StatewideTestRepository
  attr_reader :tests, :statewide_tests
  def initialize
    @statewide_tests = {}
    @store_all_files = {}
  end

  def load_data(file_tree)
    filepath = file_tree[:statewide_testing]
    filepath.each do |source, filename|
      years = CSV.readlines(filename, headers: true, header_converters: :symbol).map(&:to_h)
      scores_by_location = years.group_by do |row|
        row[:location]
      end
      shit_together = scores_by_location.each_with_object({}) do |(name, district_data), subject_data|
        single_district_data(name, district_data, subject_data)
      end
      if source == :third_grade
        @store_all_files[3] = shit_together
      else
        @store_all_files[8] = shit_together

        # need to connect statewide_test
      end

    end
    @statewide_tests = StatewideTest.new(@store_all_files)
  end

  def find_by_name(district_name)
    statewide_tests[0].class_data[district_name]
    # returns either nil or an instance of StatewideTest having done a case insensitive search

  end

  def single_subject_data(subject, data, district_data)
    one_subject_data = data.each_with_object({}) do |row, subject_data|
      subject_data[row[:timeframe].to_i] = sanitize_data_to_na(row[:data])
    end
    district_data[subject.downcase.gsub(/\W/,'_').to_sym] = one_subject_data
  end

  def single_district_data(name, district_data, subject_data)
    grouped_data = group_by_subject(district_data)
    subject_data[name] = grouped_data.each_with_object({}) do |(subject, data), district_data|
      single_subject_data(subject, data, district_data)
    end
  end

  def group_by_subject(data)
    data.group_by { |row| row[:score] }
  end

  def sanitize_data(input)
    input.to_s.gsub!(/[\s]+/,'')
    input = input.to_f if String === input
    input
  end

  def sanitize_data_to_na(num)
    if sanitize_data(num) == 0 || sanitize_data(num).to_s.upcase.chars[0] == "N"
      "N/A"
    else
      sanitize_data(num)
    end
  end

end
