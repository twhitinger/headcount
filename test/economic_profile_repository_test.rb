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
      skip
      epr = EconomicProfileRepository.new
      epr.load_data({
        :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
        }
        })

        assert_equal 181, epr.district_groups.count
      end

      def test_string_range_int_converts_string_range_into_a_paired_array_of_integers
        skip
        epr = EconomicProfileRepository.new

        assert_equal [2005, 2009], epr.string_range_into_int("2005-2009")
      end

      def test_match_timeframe_to_data_creates_hash_of_time_frame_to_data
        skip
        epr = EconomicProfileRepository.new

        input = [ {:timeframe=>"2005-2009", :data=>"56222"},
          {:timeframe=>"2006-2010", :data=>"56456"},
          {:timeframe=>"2008-2012", :data=>"58244"} ]

          epr.match_timeframe_to_data_range(input)

          output =     { [2005, 2009] => 56222,
            [2006, 2010] => 56456,
            [2008, 2012] => 58244 }

            assert_equal output, epr.match_timeframe_to_data_range(input)
          end
        end
