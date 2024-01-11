require 'vandelay/services/patients'
require 'vandelay/services/param_validator'

module Vandelay
  module REST
    module PatientsPatientBase
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.with_patient(patient_id)
        if Vandelay::Services::ParamValidator.valid?(patient_id, Integer)
          status_code = 200
          result = Vandelay::REST::PatientsPatientBase.patients_srvc.retrieve_one(patient_id)
          if result.nil?
            status_code = 404
            result = { message: "Patient with ID #{patient_id} not found!" }
          end
        else
          status_code = 400
          result = { message: "Invalid patient ID provided!" }
        end
        yield(status_code, result)
      end
    end
  end
end
