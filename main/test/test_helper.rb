ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'rack/test'

require 'my_app'

class Test::Unit::TestCase

  def app
    MyApp
  end

end