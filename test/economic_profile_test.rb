require_relative '../lib/economic_profile_repository'
require_relative '../lib/economic_profile'
require_relative 'test_helper'


class EconomicProfileTest < Minitest::Test

  def test_economic_profile_is_organized_upon_init
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543},
    :name => "ACADEMY 20"}
    expected = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543}}

    economic_profile = EconomicProfile.new(data)

    assert_equal expected, economic_profile.economic_data
  end

  def test_median_household_income_in_year_averages_all
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543},
    :name => "ACADEMY 20"}
    economic_profile = EconomicProfile.new(data)

    ep1 = economic_profile.median_household_income_in_year(2005)
    ep2 = economic_profile.median_household_income_in_year(2009)

    assert_equal 50000, ep1
    assert_equal 55000, ep2
  end

  def test_median_household_income_average
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543},
    :name => "ACADEMY 20"}

    economic_profile = EconomicProfile.new(data)

    assert_equal 55000, economic_profile.median_household_income_average
  end

  def test_children_in_poverty_in_year_method
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543},
    :name => "ACADEMY 20"}

    economic_profile = EconomicProfile.new(data)

    assert_equal 0.184, economic_profile.children_in_poverty_in_year(2012)
  end

  def test_free_or_reduced_price_lunch_percentage_in_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543},
    :name => "ACADEMY 20"}

    economic_profile = EconomicProfile.new(data)

    assert_equal 0.023, economic_profile.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

  def test_free_or_reduced_price_lunch_number_in_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543},
    :name => "ACADEMY 20"}

    economic_profile = EconomicProfile.new(data)

    assert_equal 100, economic_profile.free_or_reduced_price_lunch_number_in_year(2014)
  end

  def test_title_i_in_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543},
    :name => "ACADEMY 20"}

    economic_profile = EconomicProfile.new(data)
    assert_equal 0.543, economic_profile.title_i_in_year(2015)
  end
end
