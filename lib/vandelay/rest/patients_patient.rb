require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.registered(app)
        # Render a single patient's data
        app.get '/patients/:id' do
          result = Vandelay::REST::Patients.patients_srvc.retrieve_one(params[:id])
          
          json(result.to_h)
        end

        app.get '/patients/:id/record' do
          # Render a single patient's record data from its vendor
          patient = Vandelay::REST::Patients.patients_srvc.retrieve_one(params[:id])
          result = Vandelay::Services::PatientRecords.retrieve_record_for_patient(patient)
          
          json(result)
        end
      end
    end
  end
end
