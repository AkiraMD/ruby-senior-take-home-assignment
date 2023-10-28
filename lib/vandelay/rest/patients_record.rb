require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsRecord
      TEN_MINUTES_IN_SECONDS = 10 * 60

      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.patient_records_srvc
        @patient_records_srvc ||= Vandelay::Services::PatientRecords.new(TEN_MINUTES_IN_SECONDS)
      end

      def self.registered(app)
        app.get '/patients/:patient_id/record' do |patient_id|
          patient = Vandelay::REST::PatientsRecord.patients_srvc.retrieve_one(patient_id)
          halt 404, 'Patient not found' unless patient
          patient_record = Vandelay::REST::PatientsRecord.patient_records_srvc.retrieve_record_for_patient(patient)
          halt 404, 'Vendor patient record not found' unless patient_record
          json(patient_record)
        end
      end
    end
  end
end
