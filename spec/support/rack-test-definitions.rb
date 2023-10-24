# frozen_string_literal: true

require_relative '../../server'
require 'rack/test'

# See: https://sinatrarb.com/testing.html
module RackTestDefinitions
  include Rack::Test::Methods

  def app
    RESTServer
  end
end