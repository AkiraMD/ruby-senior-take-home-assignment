require 'vandelay/services/patient_records'
require 'vandelay/rest/patients_patient_base'

module Vandelay
  module REST
    module PatientsPatientRecord
      def self.patient_records_srvc
        @patient_records_srvc ||= Vandelay::Services::PatientRecords.new
      end

      def self.registered(app)
        app.get '/patients/:patient_id/record' do
          Vandelay::REST::PatientsPatientBase.with_patient(params[:patient_id]) do |status_code, result|
            if status_code == 200
              result = Vandelay::REST::PatientsPatientRecord.patient_records_srvc.retrieve_record_for_patient(result)
              if result.nil?
                not_found(json({ message: "No patient records for Patient with ID #{params[:patient_id]} were found!" }))
              else
                json(result)
              end
            else
              status status_code
              json(result)
            end
          end
        end
      end
    end
  end
end
