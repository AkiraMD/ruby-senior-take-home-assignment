require 'yaml'

module Vandelay
  CONFIG_PATH = File.expand_path('../config.yml', File.dirname(__FILE__)).freeze

  def self.service_name
    "Vandelay Industries"
  end

  def self.system_time_now
    Time.now
  end

  def self.config
    return @config if @config

    @config = YAML.load_file(CONFIG_PATH)
    @config
  end
end
