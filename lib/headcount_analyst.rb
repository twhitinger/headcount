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
      return loop_through_all_schools
    elsif location[:across]
      loop_through_selected_schools(location[:across])
    else
      correlation = kindergarten_participation_against_high_school_graduation(location[:for])
      correlation.between?(0.6, 1.5)
    end
  end

  def loop_through_selected_schools(selected_schools)
    array = selected_schools.map do |school|
      kg = compute_kindergartner_participation_average(school)
      hs = compute_hs_grad_participation_avg(school)
      correlation = MathHelper.truncate_float(kg/hs)
    end
    compare_statewide_correlation(array)
  end

  def loop_through_all_schools
    @district_repo.districts.each do |school|
      kg = compute_kindergartner_participation_average(school.name)
      hs = compute_hs_grad_participation_avg(school.name)
      correlation = MathHelper.truncate_float(kg/hs)
      @statewide << correlation.between?(0.6, 1.5) unless school.name == "COLORADO"
    end
    compare_statewide_correlation
  end

  def compare_statewide_correlation(array = @statewide)
    occurances = array.find_all { |correlation| correlation == true }.length
    total = array.length
    (occurances.to_f / total) > 0.7
  end
end
