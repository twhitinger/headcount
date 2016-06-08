require_relative "enrollment_repository"
require_relative "district"
require "csv"
require "pp"

class DistrictRepository
  attr_reader :districts, :enrollment_repo
  def initialize(attributes = [])
    @districts = attributes
    @enrollment_repo = EnrollmentRepository.new
  end

  def find_by_name(name)
    districts.find { |district| district.name == name }
  end

  def find_all_matching(fragment)
    districts.select do |district|
      district.name.downcase.include?(fragment.downcase)
    end
  end

  def load_data(repo_id)
    generate_district_repo(repo_id)

    repo_id.each do |repo_type, files|
      auto_generate_repo(repo_type, files)
    end
    push_info_to_district
  end

  def generate_district_repo(file_tree)
    filepath = file_tree[:enrollment][:kindergarten]
    years =  CSV.foreach(filepath, headers: true, header_converters: :symbol).map(&:to_h)
    years.each do |row|
      next if find_by_name(row[:location].upcase)
      districts << District.new(name: row[:location])
    end
  end

  def auto_generate_repo(repo_type, file_tree)
    repositories = {enrollment: @enrollment_repo}
    repo = repositories[repo_type]
    repo.load_data({repo_type => file_tree})
  end

  def push_info_to_district
    districts.each do |district|
      district.enrollment = @enrollment_repo.find_by_name(district.name)
    end
  end
end
