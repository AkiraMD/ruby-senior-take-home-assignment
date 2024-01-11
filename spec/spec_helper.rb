ENV['APP_ENV'] ||= 'test'

require_relative '../boot'
require 'json'


RSpec.configure do |config|
    config.order = :random
end
