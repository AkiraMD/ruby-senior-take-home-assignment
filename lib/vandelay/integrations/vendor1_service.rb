require "vandelay/integrations/base"

module Vandelay
  module Integrations
    class Vendor1Service < Base

      def get_token_from_response(parsed_body)
        parsed_body['token']
      end

      def get_record_response(parsed_body)
       {
          "patient_id": parsed_body['id'],
          "province": parsed_body['province'],
          "allergies": parsed_body['allergies'],
          "num_medical_visits": parsed_body['recent_medical_visits']
        }
      end

      def get_token_url
        "#{@base_url}/auth/1"
      end

      def get_patient_url
        "#{@base_url}/patients/#{@patient.vendor_id}"
      end
    end
  end
end
