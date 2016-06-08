require_relative '../lib/district'
require_relative 'test_helper'


class DistrictTest < Minitest::Test

  def test_name_returns_upcase
    d1 = District.new({:name => "academy 20"})
    d2 = District.new({:name => "doNuT"})

    assert_equal "ACADEMY 20", d1.name
    assert_equal "DONUT", d2.name
  end

end
