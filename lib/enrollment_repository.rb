require_relative "enrollment"
require "csv"
require "pp"

class EnrollmentRepository
  attr_reader :enrollments
  def initialize(enrollments = [])
    @enrollments = enrollments
  end

  def load_data(file_tree)

    filepath = file_tree[:enrollment][:kindergarten]

    years =  CSV.foreach(filepath, headers: true, header_converters: :symbol).map do |row|
      {name: row[:location], row[:timeframe].to_i => row[:data].to_f }
    end

    per_enrollment_by_year = years.group_by do |row|
      row[:name]
    end

    enrollment_data = per_enrollment_by_year.map do |name, years|
      merged = years.reduce({}, :merge)
      merged.delete(:name)
      { name: name.upcase, kindergarten_participation: merged }
    end

    enrollment_data.each do |e|
      @enrollments << Enrollment.new(e)
    end
  end

  def find_by_name(name)
    @enrollments.find { |enrollment| enrollment.name.downcase == name.downcase}
  end
end
