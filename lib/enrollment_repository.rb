require_relative "enrollment"
require "csv"
require "pp"

class EnrollmentRepository
  attr_reader :enrollments

  def initialize(enrollments = [])
    @enrollments = enrollments
  end

  def find_by_name(name)
    @enrollments.find { |enrollment| enrollment.name.downcase == name.downcase}
  end

  def enrollment_by_year(years)
    per_enrollment_by_year = years.group_by do |row|
      row[:name]
    end
  end

  def enrollment_data_merge(enrollment_data)
    enrollment_data.each do |data|
      if find_by_name(data[:name])
        find_by_name(data[:name]).high_school_data.merge!({
          name: data[:name], @grade_id => data[@grade_id]
          })
        else
          @enrollments << Enrollment.new(data)
        end
      end
    end

    def load_data(file_tree)
      filepath = file_tree[:enrollment] if file_tree.has_key?(:enrollment)
      filepath.each do |source, filename|
        years =  CSV.readlines(filename, headers: true,
        header_converters: :symbol).map do |row|
          {name: row[:location], row[:timeframe].to_i => row[:data].to_f }
        end
        enrollment_data = enrollment_by_year(years).map do |name, years|
          merged = years.reduce({}, :merge)
          merged.delete(:name)
          @grade_id = (source.to_s + "_participation").to_sym
          { name: name.upcase, @grade_id => merged }
        end
        enrollment_data_merge(enrollment_data)
      end
    end
  end
