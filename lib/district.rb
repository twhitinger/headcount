require_relative 'enrollment'

class District
  attr_reader :district
  attr_accessor :enrollment

  def initialize(attributes = {})
    @district = attributes
  end

  def name
    @district.fetch(:name, nil).upcase
  end
  

end
