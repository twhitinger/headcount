require "csv"
require "pp"
class EnrollmentRepository

  def initialize(enrollments = [])
    @enrollments = enrollments
  end

  # def load_data(file_tree)
  #   # {
  #   #   :enrollment => {
  #   #     :kindergarten => "./data/Kindergartners in full-day program.csv"
  #   #   }
  #   # ????
  #
  #   {
  #   #  :name => "ACADEMY 20",
  #   #  :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
  #
  #   filepath = file_tree[:enrollment][:kindergarten]
  # years =  CSV.foreach(filepath, header: true, headers_converter: :symbol).map do |row|
  #     # { name: row[:location], row[:timeframe].to_i => row[:data].to_f }
  #   end
  #
  #   per_enrollment_by_year  = years.group_by do |row|
  #     row[:name]
  #   end
  #
  #    per_enrollment_by_year.map do |name, years|
  #      merged = years.reduce({}, :merge)
  #      merge.delete(:name)
  #      {name: name, kindergarten_participation: merged }
  #   end
  #
  #   enrollment_data.each do |e|
  #     @enrollment << Enrollment.new(e)
  #   end
  # end

  def find_by_name(name)
    @enrollments.find { |enrollment| enrollment.name == name }
    # returns either nil or an instance of Enrollment having done a case insensitive search
  end

end
