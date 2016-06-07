require "csv"
require "pp"

class DistrictRepository
  attr_reader :districts
  def initialize(districts = [])
    @districts = districts
  end

  def find_by_name(name)
    districts.find { |district| district.name == name.upcase }
  end

  def find_all_matching(fragment)

    districts.select do |district|
      district.name.downcase.include?(fragment.downcase)
    end
  end

    def load_data(file_tree)

      filepath = file_tree[:enrollment][:kindergarten]

      years =  CSV.foreach(filepath, headers: true, header_converters: :symbol).map do |row|
        {name: row[:location], row[:timeframe].to_i => row[:data].to_f }
      end

      per_district_by_year = years.group_by do |row|
        row[:name]
      end

      district_data = per_district_by_year.map do |name, years|
        merged = years.reduce({}, :merge)
        merged.delete(:name)
        { name: name, kindergarten_participation: merged }
      end

      district_data.each do |e|
        @districts << District.new(e)
      end
    end

  end
