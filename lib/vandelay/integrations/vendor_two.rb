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
    end
  end
end
