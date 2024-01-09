module Vandelay
  module Integrations
    class VendorOne
      require 'net/http'
      
      API_BASE_URL = Vandelay.config["integrations"]["vendors"]["one"]["api_base_url"]
      REQUIRED_FIELDS = ["province", "allergies",  "recent_medical_visits"]

      def initalize()
        @auth_token ||= fetch_auth_token
      end

      def fetch_auth_token
        uri = URI("http://#{API_BASE_URL}/auth/1")
        res = JSON.parse(Net::HTTP.get(uri))
        res["token"]
      end
      
      def fetch_patient_record(patient_id)
        uri = URI("http://#{API_BASE_URL}/patients/#{patient_id}")
        headers = {
          "Authorization" => "Bearer #{@auth_token}"
        }
        res = JSON.parse(Net::HTTP.get(uri, headers))
        res.slice(*REQUIRED_FIELDS)
      end
    end
  end
end