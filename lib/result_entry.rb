class ResultEntry
  attr_reader :econ_data

  def initialize(econ_data = {})
    @econ_data = econ_data
  end

  def free_and_reduced_price_lunch_rate
    econ_data[:free_and_reduced_price_lunch_rate]
  end

  def children_in_poverty_rate
    econ_data[:children_in_poverty_rate]
  end

  def high_school_graduation_rate
    econ_data[:high_school_graduation_rate]
  end

  def median_household_income
    econ_data[:median_household_income]
  end

  def name
    econ_data[:name]
  end


end
