require_relative 'district_repository'
require_relative 'helper'
class HeadcountAnalyst
  def initialize(district_repo = {})
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(location_one, location_two)
    location_one_average = compute_kindergartner_participation_average(location_one)
    location_two_average = compute_kindergartner_participation_average(location_two[:against])
    Helper.truncate_float(location_one_average/location_two_average)
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
    loc1.merge(loc2) { |k, v1, v2| Helper.truncate_float(v1/v2) }
  end

end
