require_relative '../lib/enrollment'
require_relative '../lib/helper'
require_relative 'test_helper'


class EnrollmentTest < Minitest::Test
  def test_enrollment_initialize_with_hash
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal e.enrollment_hash, {:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}
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
    e1 = Enrollment.new

    assert_equal 34.456, Helper.truncate_float(34.4564527)
    assert_equal 0.234,  Helper.truncate_float(0.23415623456245)
  end

  def test_kidergarten_participation_by_year_truncates
    e1 = Enrollment.new({:kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    e2 = Enrollment.new({:kindergarten_participation => {2007 => 0.5673456, 2001 => 0.98075, 1987 => 0.12345}})
    e3 = Enrollment.new({:kindergarten_participation => {900 => 0.3456, 1776 => 0.96784, 25555 => 0.85678}})

    assert_equal e1.kindergarten_participation_by_year, {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}
    assert_equal e2.kindergarten_participation_by_year, {2007 => 0.567, 2001 => 0.980, 1987 => 0.123}
    assert_equal e3.kindergarten_participation_by_year, {900 => 0.345, 1776 => 0.967, 25555 => 0.856}
  end

  def test_kidergarten_participation_in_year_truncates
    e1 = Enrollment.new({:kindergarten_participation => {2010 => 0.3915}})
    e2 = Enrollment.new({:kindergarten_participation => {2011 => 0.35356}})

    assert_equal e1.kindergarten_participation_in_year(2010), 0.391
    assert_equal e2.kindergarten_participation_in_year(2011), 0.353
  end
end
