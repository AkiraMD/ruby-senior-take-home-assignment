ENV['APP_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require_relative '../server'

class RestServerTest < Minitest::Test
  include Rack::Test::Methods
 
  def app
    RESTServer
  end
end
