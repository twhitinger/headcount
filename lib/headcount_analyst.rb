require_relative 'district_repository'
class HeadcountAnalyst
  def initialize(district_repo = {})
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(location_name, header)
    header = header[:against].capitalize
    state_average = compute_kindergartner_participation_average(header)
    location_average = compute_kindergartner_participation_average(location_name)
    truncate_float(location_average/state_average)
  end

  def compute_kindergartner_participation_average(location_name)
    location = @district_repo.find_by_name(location_name)
    location.enrollment.enrollment_hash[:kindergarten_participation].values.reduce(:+)/
    location.enrollment.enrollment_hash[:kindergarten_participation].length
  end

end
