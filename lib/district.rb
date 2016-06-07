class District
  attr_reader :name
  
  def initialize(hash)
    # returns the upcased string name of the district
    @name = hash[:name].upcase
  end
end
