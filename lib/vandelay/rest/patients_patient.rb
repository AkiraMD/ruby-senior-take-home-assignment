require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.registered(app)
        app.get '/patients/:id' do
          if params['id'].to_i.to_s != params['id']
            return json({ status: 422, message: "Invalid patient id", system_time: Vandelay.system_time_now.iso8601 })
          end
          result = Vandelay::REST::PatientsPatient.patients_srvc.retrieve_one(params['id'])
          if result.nil?
            return json({ status: 404, message: "Patient not found", system_time: Vandelay.system_time_now.iso8601 })
          else
            json(result)
          end
        end
      end
    end
  end
end
