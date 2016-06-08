require './lib/enrollment'

class District
  attr_reader :district
  attr_accessor :enrollment

  def initialize(attributes = {})
    @district = attributes
  end

  def name
    # returns the upcased string name of the district
    @district[:name].upcase
  end

  # def enrollment
  #
  #
  # end
end
