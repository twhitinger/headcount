class DistrictRepository
  attr_reader :district
  def initialize(district = [])
    @district = district
  end

  def find_by_name(name)
    district.find { |district| district.name == name }
  end

  def find_all_matching(fragment)

    district.select do |district|
      district.name.downcase.include?(fragment.downcase)
    end
  end

    def load_data(data)
      # return hash {  :enrollment => {
      #   :kindergarten => "./data/Kindergartners in full-day program.csv"
      # }
    end

  end
