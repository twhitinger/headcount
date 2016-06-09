require_relative 'enrollment'

class District
  attr_reader   :name
  attr_accessor :enrollment

  def initialize(attributes = {})
    # @district = attributes
    @name = attributes[:name].upcase
  end

  # def name
  #   @district.fetch(:name, nil).upcase
  # end


end
