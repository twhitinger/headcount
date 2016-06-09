require_relative "helper"
class Enrollment
  attr_reader :kindergarten_data, :high_school_data
  def initialize(attributes = {})
    @kindergarten_data = attributes
    @high_school_data = {}
  end

  def name
    kindergarten_data.fetch(:name, nil)
  end

  def kindergarten_participation_by_year

    kindergarten_data[:kindergarten_participation].reduce({}) do |result, pair|
      result.merge(pair.first => Helper.truncate_float(pair.last))
    end
  end

  def kindergarten_participation_in_year(year)
   kindergarten_participation_by_year[year]
  end

  def graduation_rate_by_year
    kindergarten_data[:high_school_graduation].reduce({}) do |result, pair|
      result.merge(pair.first => Helper.truncate_float(pair.last))
    end
  end

  def graduation_rate_in_year(year)
    graduation_rate_by_year[year]
  end
end
