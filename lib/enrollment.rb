class Enrollment
  attr_reader :enrollment_hash
  def initialize(hash)

    @enrollment_hash = hash
  end

  def kindergarten_participation_by_year(year)
    # This method returns a hash with years as keys and a truncated three-digit
    # floating point number representing a percentage for all years present in the dataset.
    year[:kindergarten_participation].each {|k, v|  year[:kindergarten_participation][k] = (v * 1000).floor / 1000.0 }
    year[:kindergarten_participation]

  end

end
