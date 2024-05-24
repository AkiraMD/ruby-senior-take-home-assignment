require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.registered(app)
        app.get '/patients/:id' do
          halt 422, json({ error: 'Invalid patient ID' }) unless params[:id].to_i.to_s == params[:id]

          result = Vandelay::REST::PatientsPatient.patients_srvc.retrieve_one(params[:id])

          halt 404, json({ error: 'Patient not found' }) if result.nil?

          json(result.to_h)
        end
      end
    end
  end
end
