require 'test_helper'

class MyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def test_root
    get '/'
    assert last_response.ok?
    assert_match /Hello world/, last_response.body
  end

end
