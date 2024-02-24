require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.patient_records_srvc
        @patient_record_srvc ||= Vandelay::Services::PatientRecords.new
      end

      def self.registered(app)
        app.get '/patient/:id' do
          # Check for valid params
          return json({ error: 'Invalid Patient Id', status: 422, system_time: Vandelay.system_time_now.iso8601 }) unless /^\d+$/.match?(params[:id])
          
          # Retreive the patient with the given ID
          result = Vandelay::REST::PatientsPatient.patients_srvc.retrieve_one(params[:id])

          # Return a 404 status code if patient is not found
          return json({ error: 'Patient not found', status: 404, system_time: Vandelay.system_time_now.iso8601 }) unless result

          json(result.to_h)
        end
      end
    end
  end
end
