require_relative "math_helper"
class Enrollment
  attr_reader :kindergarten_data, :high_school_data, :name

  def initialize(attributes = {})
    @kindergarten_data = attributes
    @high_school_data = {}
    @name = attributes[:name].upcase
  end

  def kindergarten_participation_by_year
    kindergarten_data[:kindergarten_participation].reduce({}) do |result, pair|
      result.merge(pair.first => MathHelper.truncate_float(pair.last))
    end
  end

  def kindergarten_participation_in_year(year)
   MathHelper.truncate_float(kindergarten_participation_by_year[year])
  end

  def graduation_rate_by_year
    high_school_data[:high_school_graduation_participation]\
    .reduce({}) do |result, pair|
      result.merge(pair.first => MathHelper.truncate_float(pair.last))
    end
  end

  def graduation_rate_in_year(year)
    MathHelper.truncate_float(graduation_rate_by_year[year])
  end
end
