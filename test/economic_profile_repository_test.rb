require_relative 'test_helper'
require "minitest/autorun"
require "minitest/pride"
require_relative '../lib/economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test

  def test_find_by_name_returns_value_or_nil
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })

    assert_equal nil, epr.find_by_name("cant_find")
    assert_equal 85060, epr.find_by_name("ACADEMY 20").economic_data[:median_household_income].values[0]
    assert_equal 56222, epr.find_by_name("Colorado").economic_data[:median_household_income].values[0]
  end

  def test_district_groups_returns_all_181_districts

    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
      }
    })

    assert_equal 181, epr.economic_profiles.count
  end
end
