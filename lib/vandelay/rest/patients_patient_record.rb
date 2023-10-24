require 'vandelay/services/patients'
require 'vandelay/services/patient_records'
require 'net/http'

module Vandelay
  module REST
    module PatientsPatientRecord
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.registered(app)
        app.get '/patients/:patient_id/record' do |patient_id|
          # TODO
          return 404
        end
      end
    end
  end
end
