require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatientRecord
      def self.patient_records_srvc
        @patient_records_srvc ||= Vandelay::Services::PatientRecords.new
      end

      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.registered(app)
        app.get '/patients/:patient_id/record' do
          if params['patient_id'].to_i.to_s != params['patient_id']
            halt json({ status: 422, message: "Invalid Patient Id", system_time: Vandelay.system_time_now.iso8601 })
          end

          patient = Vandelay::REST::PatientsPatientRecord.patients_srvc.retrieve_one(params['patient_id'])         
          if patient.nil?
            halt json({ status: 404, message: "Patient not found", system_time: Vandelay.system_time_now.iso8601 })
          end

          result = Vandelay::REST::PatientsPatientRecord.patient_records_srvc.retrieve_record_for_patient(patient)
          if result.nil?
            json({ status: 404, message: "Unable to find patient record", system_time: Vandelay.system_time_now.iso8601 })
          else
            json(result)
          end
        end     
      end
    end
  end
end
