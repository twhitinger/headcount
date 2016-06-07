require './lib/enrollment_repository'
require './lib/enrollment'
require './test/test_helper'


class EnrollmentRepositoryTest < Minitest::Test

  def test_loading_enrollments
    skip
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
      })
      enrollment = er.find_by_name("ACADEMY 20")

      assert_equal "ACADEMY 20", enrollment.name
    end

    def test_
      e1 = Enrollment.new({:name => "ACADEMY 20"})
      e2 = Enrollment.new({:name => "Pizza acadmemy 30"})
      er = EnrollmentRepository.new([e1, e2])

      enrollment = er.find_by_name("ACADEMY 20")

      assert_equal "ACADEMY 20", enrollment.name
    end
  end
