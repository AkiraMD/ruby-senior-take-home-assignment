require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.registered(app)
        app.get '/patients/:patient_id' do |patient_id|
          patient = Vandelay::REST::PatientsPatient.patients_srvc.retrieve_one(patient_id)
          halt 404, 'Patient not found' unless patient
          json(patient)
        end
      end
    end
  end
end
