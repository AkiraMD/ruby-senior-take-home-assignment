require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsRecord
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.patient_records_srvc
        @patient_records_srvc ||= Vandelay::Services::PatientRecords.new
      end

      def self.registered(app)
        app.get '/patients/:id/record' do
          halt 422, json({ error: 'Invalid patient ID' }) unless params[:id].to_i.to_s == params[:id]

          result = Vandelay::REST::PatientsPatient.patients_srvc.retrieve_one(params[:id])

          halt 404, json({ error: 'Patient not found' }) if result.nil?

          record = Vandelay::REST::PatientsRecord.patient_records_srvc.retrieve_record_for_patient(result)

          halt 404, json({ error: 'Patient not found' }) if record.nil?

          json(record)
        end
      end
    end
  end
end
