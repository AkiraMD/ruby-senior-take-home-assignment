require 'net/http'
require 'json'

module Vandelay
  module Integrations
    module V1
      class ApiClient
        def retrieve_patient_record(patient_id)
          # Create a new Net::HTTP object with the specified host ,port
          http = Net::HTTP.new(host, 80)

          # Create a new HTTP GET request with the specified path and added Authorization , Content-Type
          request = Net::HTTP::Get.new(path + "#{patient_id}")
          request['Authorization'] = "Bearer #{get_bearer_token(token_url)}"
          request['Content-Type'] = 'application/json'

          # Send the HTTP request and store the response
          response = http.request(request)

          return { error: "HTTP request failed with status code: #{response.code}", status: 422 } unless response.is_a? Net::HTTPSuccess

          # Parse the response body as JSON and return the extracted required information
          get_required_info(JSON.parse(response.body))
        end

        private

        def get_bearer_token(token_url)
          uri = URI(token_url)
          # Send the HTTP request and store the response
          response = Net::HTTP.get_response(uri)

          # Determine whether to return a token or an error based on the response received
          if response.is_a? Net::HTTPSuccess
            response['token'] || response['auth_token']
          else
            { error: "HTTP request failed with status code: #{response.code}", status: 422 }
          end
        end

        def get_required_info(response)
          {
            patient_id: response['id'],
            province: response['province'] || response['province_code'],
            allergies: response['allergies'] || response['allergies_list'],
            num_medical_visits: response['recent_medical_visits'] || response['medical_visits_recently']
          }
        end
      end
    end
  end
end

