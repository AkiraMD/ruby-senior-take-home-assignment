require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.validate_and_grab_patient(id_patient)
        if id_patient == 0
          return { status: 400, error: 'malformed_url - invalid id parameter' }
        end
        service = Vandelay::Services::Patients.new
        result = service.retrieve_one(id_patient)
        if result.nil?
          { success: false, status: 404, error: 'patient not found' }
        else
          { success: true, status: 200, record: result }
        end
      end

      def self.registered(app)
        app.get '/patients/:id' do
          result = Vandelay::REST::PatientsPatient::validate_and_grab_patient(params[:id].to_i)
          status result[:status]
          if result[:success]
            json(result[:record].to_h)
          else
            json({error: result[:error]})
          end
        end

        app.get '/patients/:patient_id/record' do
          result = Vandelay::REST::PatientsPatient::validate_and_grab_patient(params[:patient_id].to_i)
          status result[:status]
          if result[:success]
            patient = result[:record]
            service = Vandelay::Services::PatientRecords.new
            records = service.retrieve_record_for_patient(patient)
            json(records)
          else
            json({error: result[:error]})
          end
        end
      end
    end
  end
end
