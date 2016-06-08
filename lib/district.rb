require_relative 'enrollment'

class District
  attr_reader :district
  attr_accessor :enrollment

  def initialize(attributes = {})
    @district = attributes

  end

  def name
    # returns the upcased string name of the district
    @district.fetch(:name, nil)
  end

  # def enrollment
  #
  #
  # end
end
