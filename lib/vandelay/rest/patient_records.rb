require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientRecords
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.patient_records_srvc
        @patient_record_srvc ||= Vandelay::Services::PatientRecords.new
      end

      def self.registered(app)
        app.get '/patient/:id/record' do
          # Check for valid params
          return json({ error: 'Invalid Patient Id', status: 422, system_time: Vandelay.system_time_now.iso8601 }) unless /^\d+$/.match?(params[:id])

          results = Vandelay::REST::PatientRecords.patient_record(params[:id])
          json(results)
        end
      end

      def self.patient_record(patient_id)
        patient = Vandelay::REST::Patients.patients_srvc.retrieve_one(patient_id)

        # Return a 404 status code if patient is not found
        return { error: 'Patient not found', status: 404, system_time: Vandelay.system_time_now.iso8601 } unless patient

        # Retreive the patient with the given ID
        patient_record = Vandelay::REST::PatientRecords.patient_records_srvc.retrieve_record_for_patient(patient)

        # Return a 404 status code if patient record is not found
        return { error: 'Patient not found', status: 404, system_time: Vandelay.system_time_now.iso8601 } unless patient_record

        # Return patient record
        patient_record
      end
    end
  end
end
