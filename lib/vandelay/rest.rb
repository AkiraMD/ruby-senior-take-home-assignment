Dir[File.dirname(__FILE__) + '/rest/**.rb'].each {|rb| require_relative rb }

module Vandelay
  module REST
    def self.registered(app)
      Vandelay::REST.constants.each do |klass_sym|
        endpoint_module = Vandelay::REST.const_get(klass_sym)
        app.register endpoint_module
      end
    end
  end
end
