require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.registered(app)
        app.get '/patients/:id' do |patient_id|
          patient = Vandelay::Services::Patients.new.retrieve_one(patient_id.to_i)
          if patient.nil?
            status 404
            json({ error: "Patient with id #{patient_id} not found" })
          else
            json(patient.to_h)
          end
        end
      end
    end
  end
end
