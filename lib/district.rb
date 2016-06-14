require_relative 'enrollment'

class District
  attr_reader   :name
  attr_accessor :enrollment, :statewide_test

  def initialize(attributes = {})
    @name = attributes[:name].upcase
  end
end
