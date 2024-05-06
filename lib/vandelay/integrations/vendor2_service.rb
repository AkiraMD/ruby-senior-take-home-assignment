require "vandelay/integrations/base"

module Vandelay
  module Integrations
    class Vendor2Service < Base

      def get_token_from_response(parsed_body)
        parsed_body['auth_token']
      end

      def get_record_response(parsed_body)
        {
          "patient_id": parsed_body['id'],
          "province": parsed_body['province_code'],
          "allergies": parsed_body['allergies_list'],
          "num_medical_visits": parsed_body['medical_visits_recently']
        }
      end

      def get_token_url
        "#{@base_url}/auth_tokens/1"
      end

      def get_patient_url
        "#{@base_url}/records/#{@patient.vendor_id}"
      end

    end
  end
end
