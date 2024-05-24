require_relative 'api_client_base'

module Vandelay
  module Integrations
    class VendorTwo < Vandelay::Integrations::ApiClientBase
      def config_name
        'two'
      end

      def resource_url
        "#{api_base_url}/records"
      end

      def token_url
        "#{api_base_url}/auth_tokens/1"
      end

      def token_name
        'auth_token'
      end

      def get_patient_record(patient_id)
        json = super

        {
          province: json['province_code'],
          allergies: json['allergies_list'],
          num_medical_visits: json['medical_visits_recently']
        }
      end
    end
  end
end
