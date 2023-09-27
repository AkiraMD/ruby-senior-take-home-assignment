require 'json'
require 'sinatra/base'
require 'sinatra/json'

require_relative './boot'
require 'vandelay/rest'

class RESTServer < Sinatra::Base
  configure do
    set :port, 3087
    set :bind, '0.0.0.0'
    set :app_file, __FILE__
    set :root, File.dirname(__FILE__) + "/lib/vandelay/rest"
    set :server, %w[puma]
    set :json_encoder, :to_json
  end

  register Vandelay::REST
end
