module Vandelay
  module REST
    module SystemStatus
      def self.registered(app)
        app.get '/system_status' do
          json({ status: 'OK', system_time: Vandelay.system_time_now.iso8601 })
        end
      end
    end
  end
end
