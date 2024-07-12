require 'json'
require 'vandelay/services/patients'

module Vandelay
  module REST
    module VendorOne
      def self.registered(app)
        db_content = JSON.parse(File.read('externals/mock_api_one/db.json'), symbolize_names: true)
        patients_data = db_content[:patients]
        auth_data = db_content[:auth]
        routes_data = JSON.parse(File.read('externals/mock_api_one/routes.json'), symbolize_names: true)
        auth_route = routes_data[:"/auth"]

        app.get auth_route do
          content_type :json
          auth_token = auth_data.find { |auth| auth[:id].to_s == '1' }
          { token: auth_token ? auth_token[:token] : "not_found" }.to_json
        end

        app.get '/patients' do
          content_type :json
          authenticate_vendor_one!
          patients_data.to_json
        end

        app.get '/patients/:id' do
          content_type :json
          authenticate_vendor_one!
          patient = patients_data.find { |p| p[:id].to_i == params[:id].to_i }
          if patient
            patient_hash = {
              id: patient[:id],
              full_name: patient[:full_name],
              province: patient[:province],
              dob: patient[:dob],
              allergies: patient[:allergies],
              recent_medical_visits: patient[:recent_medical_visits]
            }
            patient_hash.to_json
          else
            status 404
            { error: "Patient not found" }.to_json
          end
        end

        app.helpers do
          def authenticate_vendor_one!
            provided_token = request.env["HTTP_AUTHORIZATION"]&.split(' ')&.last
            db_content = JSON.parse(File.read('externals/mock_api_one/db.json'), symbolize_names: true)
            auth_data = db_content[:auth]

            unless auth_data.any? { |auth| auth[:token] == provided_token }
              halt 401, { 'Content-Type' => 'application/json' }, { error: "Unauthorized" }.to_json
            end
          end
        end
      end
    end
  end
end
