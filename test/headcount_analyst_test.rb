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
    assert_equal ({2007=>0.992, 2006=>1.05, 2005=>0.96, 2004=>1.257,
    2008=>0.717, 2009=>0.652, 2010=>0.681, 2011=>0.727,
    2012=>0.688, 2013=>0.694, 2014=>0.661}),
    ha.kindergarten_participation_rate_variation_trend('ACADEMY 20',
    :against => 'COLORADO')
    end

    def test_kindergarten_vs_high_school
    
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
    }
    })
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.641, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
    end

    def test_kindergarten_vs_high_school_prediction
    
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
    }
    })
    ha = HeadcountAnalyst.new(dr)

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
    end

    def test_looping_through_each_district
    
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
    }
    })
    ha = HeadcountAnalyst.new(dr)


    refute ha.compare_all_participation
    end

    def test_find_if_correlates_statewide_returns_boolean
    
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
    }
    })
    ha = HeadcountAnalyst.new(dr)

    assert_instance_of FalseClass, ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
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

    assert_instance_of TrueClass, ha.kindergarten_participation_correlates_with_high_school_graduation(:across => ['ACADEMY 20', 'BRIGHTON 27J', 'BRIGGSDALE RE-10', 'BUENA VISTA R-31'])
    end

    def test_high_poverty_and_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"},
    :economic_profile => {
    :median_household_income => "./data/Median household income.csv",
    :children_in_poverty => "./data/School-aged children in poverty.csv",
    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"
    }
    })
    e1 = {:name=>"DELTA COUNTY 50(J)", :free_and_reduced_price_lunch_rate=>4593, :children_in_poverty_rate=>0.1767305882352941, :high_school_graduation_rate=>0.8325039999999999}
    e2 = {:name=>"FOUNTAIN 8", :free_and_reduced_price_lunch_rate=>5170, :children_in_poverty_rate=>0.16549176470588234, :high_school_graduation_rate=>0.8320219999999999}
    ha = HeadcountAnalyst.new(dr)
    rs = ha.high_poverty_and_high_school_graduation


    assert_instance_of ResultSet, rs
    assert_equal 2 , rs.matching_districts.count
    assert_equal e1, rs.matching_districts.first.econ_data
    assert_equal e2, rs.matching_districts.last.econ_data
    end

    def test_access_data_from_matching_districts
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"},
    :economic_profile => {
    :median_household_income => "./data/Median household income.csv",
    :children_in_poverty => "./data/School-aged children in poverty.csv",
    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"
    }
    })
    ha = HeadcountAnalyst.new(dr)
    rs = ha.high_poverty_and_high_school_graduation


    assert_equal "DELTA COUNTY 50(J)", rs.matching_districts.first.name
    assert_equal 4593, rs.matching_districts.first.free_and_reduced_price_lunch_rate
    assert_equal 0.1767305882352941, rs.matching_districts.first.children_in_poverty_rate
    assert_equal 0.8325039999999999, rs.matching_districts.first.high_school_graduation_rate
    assert_instance_of ResultEntry, rs.statewide_average
    assert_equal 3151, rs.statewide_average.free_and_reduced_price_lunch_rate
    assert_equal 0.16491292810457553, rs.statewide_average.children_in_poverty_rate
    assert_equal 0.751708, rs.statewide_average.high_school_graduation_rate
    end


    def test_high_income_disparity

    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"},
    :economic_profile => {
    :median_household_income => "./data/Median household income.csv",
    :children_in_poverty => "./data/School-aged children in poverty.csv",
    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"
    }
    })
    ha = HeadcountAnalyst.new(dr)
    rs = ha.high_income_disparity

    assert_instance_of ResultSet, rs
    end

    def test_high_income_disparity_can_access_matching_district_data

    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"},
    :economic_profile => {
    :median_household_income => "./data/Median household income.csv",
    :children_in_poverty => "./data/School-aged children in poverty.csv",
    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"
    }
    })
    e1 = {:name=>"HINSDALE COUNTY RE 1", :median_household_income=>63265, :children_in_poverty_rate=>0.20504235294117648}
    e2 = {:name=>"KIT CARSON R-1", :median_household_income=>60633, :children_in_poverty_rate=>0.18687882352941176}
    ha = HeadcountAnalyst.new(dr)
    rs = ha.high_income_disparity

    assert_equal 2, rs.matching_districts.count
    assert_equal e1, rs.matching_districts.first.econ_data
    assert_equal e2, rs.matching_districts.last.econ_data
    assert_equal "HINSDALE COUNTY RE 1", rs.matching_districts.first.name
    assert_equal 63265, rs.matching_districts.first.median_household_income
    assert_equal 0.20504235294117648, rs.matching_districts.first.children_in_poverty_rate
    assert_instance_of ResultEntry, rs.statewide_average
    assert_equal 57408, rs.statewide_average.median_household_income
    assert_equal 0.16491292810457553, rs.statewide_average.children_in_poverty_rate
    end

    def test_kindergarten_participation_against_household_income
      dr = DistrictRepository.new
      dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv",
          :high_school_graduation => "./data/High school graduation rates.csv"},
          :economic_profile => {
            :median_household_income => "./data/Median household income.csv",
            :children_in_poverty => "./data/School-aged children in poverty.csv",
            :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"
          }
        })
      ha = HeadcountAnalyst.new(dr)

      assert_equal 0.502, ha.kindergarten_participation_against_household_income("ACADEMY 20")
    end

    def test_kindergarten_participation_correlates_with_household_income
      dr = DistrictRepository.new
      dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv",
          :high_school_graduation => "./data/High school graduation rates.csv"},
          :economic_profile => {
            :median_household_income => "./data/Median household income.csv",
            :children_in_poverty => "./data/School-aged children in poverty.csv",
            :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"
          }
          })


          ha = HeadcountAnalyst.new(dr)

          assert ha.kindergarten_participation_correlates_with_household_income(for: 'ACADEMY 20')
    end

    def test_kindergarten_participation_correlates_with_household_income_for_colorado
      dr = DistrictRepository.new
      dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv",
          :high_school_graduation => "./data/High school graduation rates.csv"},
          :economic_profile => {
            :median_household_income => "./data/Median household income.csv",
            :children_in_poverty => "./data/School-aged children in poverty.csv",
            :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"
          }
          })


          ha = HeadcountAnalyst.new(dr)

          assert ha.kindergarten_participation_correlates_with_household_income(for: 'COLORADO')
    end

    def test_kindergarten_participation_correlates_with_household_income_statewide
      dr = DistrictRepository.new
      dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv",
          :high_school_graduation => "./data/High school graduation rates.csv"},
          :economic_profile => {
            :median_household_income => "./data/Median household income.csv",
            :children_in_poverty => "./data/School-aged children in poverty.csv",
            :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"
          }
          })


          ha = HeadcountAnalyst.new(dr)

          refute ha.kindergarten_participation_correlates_with_household_income(for: 'STATEWIDE')
    end

    def test_kindergarten_participation_correlates_with_household_income
      dr = DistrictRepository.new
      dr.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv",
          :high_school_graduation => "./data/High school graduation rates.csv"},
          :economic_profile => {
            :median_household_income => "./data/Median household income.csv",
            :children_in_poverty => "./data/School-aged children in poverty.csv",
            :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"
          }
          })


          ha = HeadcountAnalyst.new(dr)

          refute ha.kindergarten_participation_correlates_with_household_income(:across => ['ACADEMY 20', 'YUMA SCHOOL DISTRICT 1', 'WILEY RE-13 JT', 'SPRINGFIELD RE-4'])
    end
end
