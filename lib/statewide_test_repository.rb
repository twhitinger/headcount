require_relative "statewide_test"
require "csv"
require "pp"

class StatewideTestRepository

  def initialize

  end

  def load_data
    # years = CSV.readlines("/Users/zackforbing/turing/1module/headcount/data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv", headers: true, header_converters: :symbol).map do |row|
    # {name: row[:location], row[:timeframe].to_i => {row[:score].downcase.to_sym => row[:data].to_f}}
    # end
    # scores_by_school = years.group_by do |row|
    #   row[:name]
    # end
    # all_scores = scores_by_school.map do |name, years|
    #   merged = years.reduce({}, :merge)
    #   merged.delete(:name)
    #   merged
    # end
    # puts all_scores

  end

end
