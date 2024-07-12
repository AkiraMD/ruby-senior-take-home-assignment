require 'json'

module Vandelay
  module REST
    module VendorTwo
      def self.registered(app)
        db_content = JSON.parse(File.read('externals/mock_api_two/db.json'), symbolize_names: true)
        records_data = db_content[:records]
        auth_data = db_content[:auth_tokens]
        routes_data = JSON.parse(File.read('externals/mock_api_two/routes.json'), symbolize_names: true)
        auth_route = routes_data[:"/auth_tokens"]

        if auth_route.nil? || auth_route.empty?
          raise "Invalid auth route in routes.json"
        end

        app.get auth_route do
          content_type :json
          auth_token = auth_data.find { |auth| auth[:id].to_s == '1' }
          { token: auth_token ? auth_token[:auth_token] : "not_found" }.to_json
        end

        app.get '/records' do
          content_type :json
          authenticate_vendor_two!
          records_data.to_json
        end

        app.get '/records/:id' do
          content_type :json
          authenticate_vendor_two!
          patient = records_data.find { |p| p[:id].to_i == params[:id].to_i }
          if patient
            {
              patient_id: patient[:id],
              province: patient[:province_code],
              allergies: patient[:allergies_list],
              num_medical_visits: patient[:medical_visits_recently]
            }.to_json
          else
            status 404
            { error: "Record not found" }.to_json
          end
        end

        app.helpers do
          def authenticate_vendor_two!
            provided_token = request.env["HTTP_AUTHORIZATION"]&.split(' ')&.last
            db_content = JSON.parse(File.read('externals/mock_api_two/db.json'), symbolize_names: true)
            auth_data = db_content[:auth_tokens]

            unless auth_data.any? { |auth| auth[:auth_token] == provided_token }
              halt 401, { 'Content-Type' => 'application/json' }, { error: "Unauthorized" }.to_json
            end
          end
        end
      end
    end
  end
end
