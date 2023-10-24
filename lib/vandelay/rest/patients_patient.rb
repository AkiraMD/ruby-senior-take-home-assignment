require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.registered(app)
        app.get '/patients/:patient_id' do |patient_id|
          result = Vandelay::REST::PatientsPatient.patients_srvc.retrieve_one patient_id

          return 404 if result.nil?

          json(result)
        end
      end
    end
  end
end
