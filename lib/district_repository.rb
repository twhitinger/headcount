require "./lib/enrollment_repository"
require "./lib/district"
require "./lib/enrollment"
require "csv"
require "pp"

class DistrictRepository
  attr_reader :districts, :enrollment_repo
  def initialize(attributes = [])
    @districts = attributes
    @enrollment_repo = EnrollmentRepository.new
    @search = nil
  end

  def find_by_name(name)
    @search = districts.find { |district| district.name == name.upcase }
    insert_data_into_district if @search
    @search
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

    enrollment_repo = @enrollment_repo.load_data(file_tree)

  end

  def insert_data_into_district
    # district = find_by_name("ACADEMY 20")
    @search.enrollment = enrollment_repo.find_by_name(@search.name)
  end
  # def insert_data_into_district
  #
  #   district = @enrollment_repo.find_by_name("ACADEMY 20")
  #   enrollment_repo = @enrollment_repo.find_by_name("ACADEMY 20")
  #     binding.pry
  #
  #   district.enrollment = @enrollment_repo.find_by_name("ACADEMY 20")
  # end

end
