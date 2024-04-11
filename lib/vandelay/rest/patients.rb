require 'vandelay/services/patients'

module Vandelay
  module REST
    module Patients
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.registered(app)
        app.get '/patients' do
          results = Vandelay::REST::Patients.patients_srvc.retrieve_all
          json(results)
        end
        app.get '/:id' do
         results = Vandelay::REST::Patients.patients_srvc.retrieve_one(params[:id])
           json(results) 
        end
        
        app.get '/patients/:id/records' do
          results = Vandelay::REST::Patients.patients_srvc.records(params[:id])
            json(results) 
         end

      end
    end 
  end
end
