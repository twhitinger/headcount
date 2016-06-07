class District
  attr_reader :district
  def initialize(hash)
    @district = hash
  end

  def name
    # returns the upcased string name of the district
    district[:name].upcase
  end
end
