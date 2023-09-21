module Vandelay
  module REST
    module Base
      def self.registered(app)
        app.get '/' do
          json({ service_name: Vandelay.service_name })
        end
      end
    end
  end
end
