require './lib/district'
require './test/test_helper'

class DistrictTest < Minitest::Test
  def test_district_initialize_with_name
    d = District.new({:name => "ACADEMY 20"})
    
    assert_equal ({:name => "ACADEMY 20"}), d.district_name
  end

  def test_name_returns_upcase
    d = District.new({:name => "academy 20"})

    assert_equal "ACADEMY 20", d.name
  end
end
