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
      assert_equal 0.447, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
    end
    def test_kindergarten_participation_rate_variation_trend

      dr = DistrictRepository.new
      dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
        })
        ha = HeadcountAnalyst.new(dr)
        assert_equal ({2007=>0.992, 2006=>1.05, 2005=>0.96, 2004=>1.257, 2008=>0.717, 2009=>0.652, 2010=>0.681, 2011=>0.727, 2012=>0.688, 2013=>0.694, 2014=>0.661}),ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
      end
    end
