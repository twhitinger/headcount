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
  end

  def find_by_name(name)
    districts.find { |district| district.name == name.upcase }
  end

  def find_all_matching(fragment)
    districts.select do |district|
      district.name.downcase.include?(fragment.downcase)
    end
  end

  def load_data(repo_id)
    create_district_repo(repo_id)

    repo_id.each do |repo_type, files|
      build_correct_repo(repo_type, files)
    end
    push_info_to_district
  end

  def create_district_repo(file_tree)
    filepath = file_tree[:enrollment][:kindergarten]
    years =  CSV.foreach(filepath, headers: true, header_converters: :symbol).map(&:to_h)
    years.each do |row|
      next if find_by_name(row[:location].upcase)
      districts << District.new(name: row[:location])
    end
  end

  def build_correct_repo(repo_type, file_tree)
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
