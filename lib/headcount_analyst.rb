require_relative 'district_repository'
class HeadcountAnalyst
  def initialize(district_repo = {})
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(location_one, location_two)
    location_one_average = compute_kindergartner_participation_average(location_one)
    location_two_average = compute_kindergartner_participation_average(location_two[:against])
    location_one_average/location_two_average
  end

  def compute_kindergartner_participation_average(location_name)
    location = @district_repo.find_by_name(location_name)
    location.enrollment.enrollment_hash[:kindergarten_participation].values.reduce(:+)/
    location.enrollment.enrollment_hash[:kindergarten_participation].length
  end

  def kindergarten_participation_rate_variation_trend(location_one, location_two)
    
    ('ACADEMY 20', :against => 'COLORADO')

  end

end
