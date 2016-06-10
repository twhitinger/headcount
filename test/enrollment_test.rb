require_relative '../lib/enrollment_repository'
require_relative '../lib/enrollment'
require_relative '../lib/math_helper'
require_relative 'test_helper'


class EnrollmentTest < Minitest::Test
  def test_enrollment_initialize_with_hash
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal ({:name => "ACADEMY 20", :kindergarten => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}), e.kindergarten_data
  end

  def test_name_method_returns_correct
    e1 = Enrollment.new({:name => "ACADEMY 20"})
    e2 = Enrollment.new({:name => "DANCE"})
    e3 = Enrollment.new({:name => "THEMONKEYISBLUE"})

    assert_equal "ACADEMY 20", e1.name
    assert_equal "DANCE", e2.name
    assert_equal "THEMONKEYISBLUE", e3.name
  end

  def test_truncate_float
    e1 = Enrollment.new({:name => "test"})

    assert_equal 34.456, MathHelper.truncate_float(34.4564527)
    assert_equal 0.234,  MathHelper.truncate_float(0.23415623456245)
  end


  def test_kindergarten_participation_by_year_truncates
    e1 = Enrollment.new({:name => "test", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    e2 = Enrollment.new({:name => "test", :kindergarten_participation  => {2007 => 0.5673456, 2001 => 0.98075, 1987 => 0.12345}})
    e3 = Enrollment.new({:name => "test", :kindergarten_participation  => {900 => 0.3456, 1776 => 0.96784, 25555 => 0.85678}})

    assert_equal ({2010 => 0.391, 2011 => 0.353, 2012 => 0.267}), e1.kindergarten_participation_by_year
    assert_equal ({2007 => 0.567, 2001 => 0.980, 1987 => 0.123}), e2.kindergarten_participation_by_year
    assert_equal ({900 => 0.345, 1776 => 0.967, 25555 => 0.856}), e3.kindergarten_participation_by_year
  end



  def test_kindergarten_participation_in_year_truncates
    e1 = Enrollment.new({:name => "test", :kindergarten_participation => {2010 => 0.3915}})
    e2 = Enrollment.new({:name => "test", :kindergarten_participation => {2011 => 0.35356}})

    assert_equal 0.391, e1.kindergarten_participation_in_year(2010)
    assert_equal 0.353, e2.kindergarten_participation_in_year(2011)
  end

  def test_enrollment_loads_second_file
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
      })
    enrollment = er.find_by_name("ACADEMY 20")

    assert_instance_of Enrollment, enrollment
  end

  def test_enrollment_grad_rate_by_year
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
      })
    enrollment1 = er.find_by_name("ACADEMY 20")
    enrollment2 = er.find_by_name("COLORADO")

    assert_equal ({2010=>0.895, 2011=>0.895, 2012=>0.889, 2013=>0.913, 2014=>0.898}), enrollment1.graduation_rate_by_year
    assert_equal ({2010=>0.724, 2011=>0.739, 2012=>0.753, 2013=>0.769, 2014=>0.773}), enrollment2.graduation_rate_by_year
  end

  def test_enrollment_graduation_rate_in_year
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
      })
    enrollment = er.find_by_name("ACADEMY 20")

    assert_equal 0.895, enrollment.graduation_rate_in_year(2010)
    assert_equal 0.895, enrollment.graduation_rate_in_year(2011)
    assert_equal 0.889, enrollment.graduation_rate_in_year(2012)
    assert_equal nil, enrollment.graduation_rate_in_year(2032)
  end
end
