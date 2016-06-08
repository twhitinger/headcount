require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'
require_relative 'test_helper'


class HeadcountAnalystTest < Minitest::Test
  def test_headcount_is_existing
    ha = HeadcountAnalyst.new
    assert ha
  end

  def test_initialize_headcount_with_district
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    assert ha
  end

  def test_kindergarten_participation_rate_variation

    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
      })
    ha = HeadcountAnalyst.new(dr)
    assert_equal 0.766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end
end
