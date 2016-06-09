require_relative 'district_repository'
require_relative 'math_helper'
class HeadcountAnalyst
  def initialize(district_repo = {})
    @district_repo = district_repo
    @statewide = []
  end

  def kindergarten_participation_rate_variation(location_one, location_two)
    location_one_average = compute_kindergartner_participation_average(location_one)
    location_two_average = compute_kindergartner_participation_average(location_two[:against])
    MathHelper.truncate_float(location_one_average/location_two_average)
  end

  def compute_kindergartner_participation_average(location_name)
    location = @district_repo.find_by_name(location_name)
    location.enrollment.kindergarten_data[:kindergarten_participation].values.reduce(:+)/
    location.enrollment.kindergarten_data[:kindergarten_participation].length
  end

  def kindergarten_participation_rate_variation_trend(location_one, location_two)
    location1 = @district_repo.find_by_name(location_one)
    loc1 = location1.enrollment.kindergarten_data[:kindergarten_participation]
    location2 = @district_repo.find_by_name(location_two[:against])
    loc2 = location2.enrollment.kindergarten_data[:kindergarten_participation]
    loc1.merge(loc2) { |k, v1, v2| MathHelper.truncate_float(v1/v2) }
  end

  def compute_hs_grad_participation_avg(location_name)
    location = @district_repo.find_by_name(location_name)
    location.enrollment.high_school_data[:high_school_graduation_participation].values.reduce(:+)/
    location.enrollment.high_school_data[:high_school_graduation_participation].length
  end

  def kindergarten_participation_against_high_school_graduation(location_one)
    kg_avg = compute_kindergartner_participation_average(location_one)
    hs_avg = compute_hs_grad_participation_avg(location_one)
    MathHelper.truncate_float(kg_avg/hs_avg)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(location)
    if location[:for] == "STATEWIDE"
      return loop_through_schools
      #shit
    else
      #return a boolean if not "STATEWIDE"
      correlation = kindergarten_participation_against_high_school_graduation(location[:for])
      correlation.between?(0.6, 1.5)
    end
  end
  # ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE') # => true
  def loop_through_schools
    @district_repo.districts.each do |school|

      kg = compute_kindergartner_participation_average(school.name)
      hs = compute_hs_grad_participation_avg(school.name)
      correlation = MathHelper.truncate_float(kg/hs)
      @statewide << correlation.between?(0.6, 1.5) unless school.name == "COLORADO"
    end
    compare_statewide_correlation
  end

  def compare_statewide_correlation
    occurances = @statewide.find_all { |correlation| correlation == true }.length
    total = @statewide.length
    if (occurances.to_f / total) > 0.7
      true
    else
      false
    end
  end
end
