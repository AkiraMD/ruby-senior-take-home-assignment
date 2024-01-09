module Vandelay
  module Integrations
    class VendorTwo
      require 'net/http'
      
      API_BASE_URL = Vandelay.config["integrations"]["vendors"]["two"]["api_base_url"]
      REQUIRED_FIELDS = ["province_code", "allergies_list",  "medical_visits_recently"]

      def initalize()
        @auth_token ||= fetch_auth_token
      end

      def fetch_auth_token
        uri = URI("http://#{API_BASE_URL}/auth_tokens/1")
        res = JSON.parse(Net::HTTP.get(uri))
        res["auth_token"]
      end
      
      def fetch_patient_record(patient_id)
        uri = URI("http://#{API_BASE_URL}/records/#{patient_id}") 
        headers = {
          "Authorization" => "Bearer #{@auth_token}"
        }
        res = JSON.parse(Net::HTTP.get(uri, headers))
        res.slice(*REQUIRED_FIELDS)
      end
    end
  end
end
