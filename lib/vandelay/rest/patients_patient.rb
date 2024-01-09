require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.registered(app)
        app.get '/patients/patient/:id' do
          id = params[:id]
          result = Vandelay::REST::Patients.patients_srvc.retrieve_one(id)
          if result.nil?
            json({ error: "No record found for id: #{id}"})
          else
            json(result.to_h)
          end
        end
      end
    end
  end
end
