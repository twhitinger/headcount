require_relative '../lib/enrollment_repository'
require_relative '../lib/enrollment'
require_relative 'test_helper'


class EnrollmentRepositoryTest < Minitest::Test

  def test_loading_enrollments

    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
      })
      enrollment1 = er.find_by_name("ACADEMY 20")
      enrollment2 = er.find_by_name("FUBAR ACADEMY")
      enrollment3 = er.find_by_name("academy 20")

      assert_equal "ACADEMY 20", enrollment1.name
      refute enrollment2
      assert_equal "ACADEMY 20", enrollment3.name
    end

    def test_find_by_name

      e1 = Enrollment.new({:name => "ACADEMY 20"})
      e2 = Enrollment.new({:name => "Pizza acadmemy 30"})
      er = EnrollmentRepository.new([e1, e2])

      enrollment1 = er.find_by_name("ACADEMY 20")
      enrollment2 = er.find_by_name("squire")

      assert_equal "ACADEMY 20", enrollment1.name
      refute enrollment2
    end

    def test_add_support_for_another_file
      er = EnrollmentRepository.new
      er.load_data({
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv",
          :high_school_graduation => "./data/High school graduation rates.csv"
        }
        })

        enrollment = er.find_by_name("ACADEMY 20")
        assert enrollment
      end
    end
