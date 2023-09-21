require 'vandelay/services/patients'

module Vandelay
  module REST
    module Patients
      def self.registered(app)
        app.get '/patients' do
          results = Vandelay::Services::Patients.new.retrieve_all
          json(results)
        end
      end
    end
  end
end
