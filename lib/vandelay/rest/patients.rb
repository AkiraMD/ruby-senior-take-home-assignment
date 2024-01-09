require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module Patients
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.patient_records_srvc
        @patient_records_srvc ||= Vandelay::Services::PatientRecords.new
      end

      def self.registered(app)
        app.get '/patients' do
          results = Vandelay::REST::Patients.patients_srvc.retrieve_all
          json(results)
        end

        app.get '/patients/:patient_id/record' do
          patient_id = params[:patient_id]
          patient = Vandelay::REST::Patients.patients_srvc.retrieve_one(patient_id)
          record = Vandelay::REST::Patients.patient_records_srvc.retrieve_record_for_patient(patient)
          if record.empty?
            json({ error: "No record found for patient_id: #{patient_id}"})
          else
            json(record.to_h)
          end
        end
      end
    end
  end
end
