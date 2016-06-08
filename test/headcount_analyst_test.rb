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
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
      })
      ha = HeadcountAnalyst.new(dr)

      # assert_equal 0.766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
      assert_equal 1.234, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')

    end
    def test_kindergarten_participation_rate_variation
      dr = DistrictRepository.new
      dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
        })
        ha = HeadcountAnalyst.new(dr)

        assert_equal ({ 2009 => 0.652, 2010 => 0.681, 2011 => 0.728 }),ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
      end
    end
