class District
  attr_reader :district_name
  def initialize(hash)
    @district_name = hash
  end

  def name
    # returns the upcased string name of the district
    district_name[:name].upcase
  end
end
