require './lib/district'
require './test/test_helper'


class DistrictTest < Minitest::Test

  def test_name_returns_upcase
    d = District.new({:name => "academy 20"})

    assert_equal "ACADEMY 20", d.name
  end
end
