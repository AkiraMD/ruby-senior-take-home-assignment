require 'vandelay/rest/patients_patient_base'

module Vandelay
  module REST
    module PatientsPatient
      def self.registered(app)
        app.get '/patients/:patient_id' do
          Vandelay::REST::PatientsPatientBase.with_patient(params[:patient_id]) do |status_code, result|
            status status_code
            json(result)
          end
        end
      end
    end
  end
end
