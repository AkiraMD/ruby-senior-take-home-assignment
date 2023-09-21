require 'json'
require 'sinatra/base'
require 'sinatra/json'

BASE_PATH = File.dirname(File.absolute_path(__FILE__))
$: << BASE_PATH + "/lib"

require 'vandelay'
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
