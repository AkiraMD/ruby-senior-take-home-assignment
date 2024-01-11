require 'vandelay/services/patients'
require 'vandelay/services/patient_records'
require 'vandelay/services/param_validator'

module Vandelay
  module REST
    module PatientsPatient
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.registered(app)
        app.get '/patients/:patient_id' do
          if Vandelay::Services::ParamValidator.valid?(params[:patient_id], Integer)
            result = Vandelay::REST::Patients.patients_srvc.retrieve_one(params[:patient_id])
            if result.nil?
              not_found(json({ message: "Patient with ID #{params[:patient_id]} not found!" }))
            else
              json(result)
            end
          else
            halt 400, json({ message: "Invalid patient ID provided!" })
          end
        end
      end
    end
  end
end
