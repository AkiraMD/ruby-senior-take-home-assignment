require 'vandelay/services/patients'
require 'vandelay/services/patient_records'
require 'net/http'

module Vandelay
  module REST
    module PatientsPatientRecord
      def self.registered(app)
        def self.patients_srvc
          @patients_srvc ||= Vandelay::Services::Patients.new
        end

        def self.patients_records_srvc
          @patients_records_srvc ||= Vandelay::Services::PatientRecords.new
        end

        app.get '/patients/:patient_id/record' do |patient_id|
          patient = Vandelay::REST::PatientsPatientRecord.patients_srvc.retrieve_one patient_id

          return 404 if patient.nil?

          vendor_result = Vandelay::REST::PatientsPatientRecord.patients_records_srvc
                                                               .retrieve_record_for_patient patient

          return 404 if vendor_result.not_found?
          return 503 if vendor_result.unexpected_error?

          json patient_id: patient_id,
               province: vendor_result.record&.province,
               allergies: vendor_result.record&.allergies,
               num_medical_visits: vendor_result.record&.num_medical_visits
        end
      end
    end
  end
end
