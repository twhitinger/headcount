require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'
require_relative 'test_helper'


class HeadcountAnalystTest < Minitest::Test
  def test_headcount_is_existing
    # skip
    ha = HeadcountAnalyst.new

    assert ha
  end

  def test_initialize_headcount_with_district
      # skip
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)

    assert ha
  end

  def test_kindergarten_participation_rate_variation
      # skip
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
      # skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    assert_equal ({2007=>0.992,
                  2006=>1.05,
                  2005=>0.96,
                  2004=>1.257,
                  2008=>0.717,
                  2009=>0.652,
                  2010=>0.681,
                  2011=>0.727,
                  2012=>0.688,
                  2013=>0.694,
                  2014=>0.661}),
                  ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_vs_high_school
      # skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.452, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  end

  def test_kindergarten_vs_high_school_prediction
      # skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_looping_through_each_district
    # skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    refute ha.loop_through_all_schools
  end

  def test_find_if_correlates_statewide_returns_boolean
    # skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

      refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
    end

    def test_find_if_correlates_selected_states_returns_boolean
      dr = DistrictRepository.new
      dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv",
          :high_school_graduation => "./data/High school graduation rates.csv"
        }
      })
      ha = HeadcountAnalyst.new(dr)

      refute ha.kindergarten_participation_correlates_with_high_school_graduation(:across => ['ACADEMY 20', 'BRIGHTON 27J', 'BRIGGSDALE RE-10', 'BUENA VISTA R-31'])
      end
     end
