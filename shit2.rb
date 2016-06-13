require "csv"
require "./lib/math_helper"
require "pry"

years = CSV.readlines("/Users/zackforbing/turing/1module/headcount/data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv", headers: true, header_converters: :symbol).map do |row|
{name: row[:location], row[:timeframe].to_i => {row[:score].downcase.to_sym => MathHelper.truncate_float(row[:data].to_f)}} #.reduce({}, :merge)
end
scores_by_school = years.group_by do |row|
  row[:name]
end

all_scores = scores_by_school.map do |name, year| #this probably needs to be deleted and/or changed
  merged = year.reduce({}, :merge)

end
binding.pry
#create a hash based on timeframe,
