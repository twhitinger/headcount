class Enrollment
  attr_reader :enrollment_hash
  def initialize(hash)

    @enrollment_hash = hash
  end

  def kindergarten_participation_by_year
    # This method returns a hash with years as keys and a truncated three-digit
    # floating point number representing a percentage for all years present in the dataset.
    enrollment_hash[:kindergarten_participation].each {|k, v|  enrollment_hash[:kindergarten_participation][k] = (v * 1000).floor / 1000.0 }
    enrollment_hash[:kindergarten_participation]
  end

  def kindergarten_participation_in_year(year)
    binding.pry
   (enrollment_hash[:kindergarten_participation][year] * 1000).floor / 1000.0
  end

end
