require_relative 'math_helper'

class EconomicProfile
  attr_accessor :name, :economic_data

  def initialize(econ_data)
    @name = econ_data[:name]
    @economic_data = {}
    format(econ_data)
  end

  def median_household_income_in_year(year)
    data = @economic_data[:median_household_income].find_all do |range, income|
      year.between?(range[0], range[1])
    end
    # raise UnknownDataError if data == []
    total = data.reduce(0) {|result, values| result += values[1]}
    total / data.count
  end

  def median_household_income_average
    sum = median_household_income.values.reduce(:+)
    sum/median_household_income.values.count
  end

  def children_in_poverty_in_year(year)
    MathHelper.truncate_float(@economic_data[:children_in_poverty][year])
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    free_or_reduced_lunch[year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    free_or_reduced_lunch[year][:total]
  end

  def title_i_in_year(year)
    @economic_data[:title_i][year]
  end

  def median_household_income
    @economic_data[:median_household_income]
  end

  def free_or_reduced_lunch
    @economic_data[:free_or_reduced_price_lunch]
  end

  def format(econ_data)
    econ_data.each_pair do |symbol_id, econ_data|
      next if symbol_id == :name
      @economic_data[symbol_id] = {}
      econ_data.each do |timeframe, data|
        @economic_data[symbol_id][timeframe] = data
      end
    end
  end

end
