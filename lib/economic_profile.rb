class EconomicProfile

  def median_household_income_in_year(year)
    # This method takes one parameter:
    #
    # year as an integer
    # A call to this method with an unknown year should raise an
    # UnknownDataError.
    #
    # To derive this number, we will average the values for all of the year
    # ranges in which your requested year appears.
    #
    # The method returns an integer.
    #
    # Example:
    #
    # economic_profile.median_household_income_in_year(2005)
    # => 50000
    # economic_profile.median_household_income_in_year(2009)
    # => 55000
  end

  def median_household_income_average
    # This method takes no parameters. It returns an integer averaging the
    # known median household incomes.
    # This should be an average of the reported income from all the available
    # year ranges.
    #
    # Example:
    #
    # economic_profile.median_household_income_average
    # => 55000
  end

  def children_in_poverty_in_year(year)
    # This method takes one parameter:
    #
    # year as an integer
    # A call to this method with an unknown year should raise an
    # UnknownDataError.
    #
    # The method returns a float representing a percentage.
    #
    # Example:
    #
    # economic_profile.children_in_poverty_in_year(2012)
    # => 0.184
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    # This method takes one parameter:
    #
    # year as an integer
    # A call to this method with an unknown year should raise an
    # UnknownDataError.
    #
    # The method returns a float representing a percentage.
    #
    # Example:
    #
    # economic_profile.free_or_reduced_price_lunch_percentage_in_year(2014)
    # => 0.023
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    # This method takes one parameter:
    #
    # year as an integer
    # A call to this method with an unknown year should raise an
    # UnknownDataError.
    #
    # The method returns an integer representing the total number of children
    # on Free or Reduced Price Lunch in that year.
    #
    # Example:
    #
    # economic_profile.free_or_reduced_price_lunch_number_in_year(2014)
    # => 100
  end


  def title_i_in_year(year)
    # This method takes one parameter:
    #
    # year as an integer
    # A call to this method with an unknown year should raise an
    # UnknownDataError.
    #
    # The method returns a float representing a percentage.
    #
    # Example:
    #
    # economic_profile.title_i_in_year(2015)
    # => 0.543
  end
end
