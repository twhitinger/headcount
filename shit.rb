require "csv"
require "./lib/statewide_test"
require "./lib/math_helper"
require "pry"

@statewide_tests = []
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
    # need to connect statewide_test
    @statewide_tests << StatewideTest.new(3 => shit_together) if source == :third_grade
  end
  binding.pry
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
load_data({
  :statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
  }
  })
