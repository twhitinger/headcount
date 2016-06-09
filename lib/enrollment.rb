require_relative "helper"
class Enrollment
  attr_reader :enrollment_hash
  def initialize(attributes = {})
    @enrollment_hash = attributes
  end

  def name
    enrollment_hash.fetch(:name, nil)
  end

  def kindergarten_participation_by_year
    enrollment_hash[:kindergarten_participation].reduce({}) do |result, pair|
      result.merge(pair.first => Helper.truncate_float(pair.last))
    end
  end

  def kindergarten_participation_in_year(year)
   kindergarten_participation_by_year[year]
  end

  # def Helper.truncate_float(float)
  #   (float * 1000).floor.abs / 1000.0
  # end

end
