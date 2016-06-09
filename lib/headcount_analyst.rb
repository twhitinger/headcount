require_relative 'district_repository'
require_relative 'math_helper'
class HeadcountAnalyst
  def initialize(district_repo = {})
    @district_repo = district_repo
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

  def compute_hs_grad_participation_avg(location_name
    
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
    correlation = kindergarten_participation_against_high_school_graduation(location[:for])
    binding.pry
    @statewide >> correlation.between?(0.6, 1.5)
    correlation.between?(0.6, 1.5)

  end

  def loop_through_schools
    # for each Enrollment instance pull out hs data, and avg all years together
    @district_repo.districts.map do |school|
# kindergarten_participation_against_high_school_graduation(school.name)
    end
  end

  def location(name)
    @district_repo.find_by_name(name)
  end
  # calculate kg_avg/hs_avg for all schools, then shovel into statewide array
end
