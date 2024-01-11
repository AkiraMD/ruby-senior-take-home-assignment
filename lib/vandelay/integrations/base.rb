require 'uri'
require 'net/http'

module Vandelay
  module Integrations
    class Base
      def patient_url
        raise NoMethodError
      end

      def port
        raise NoMethodError
      end

      def hostname
        raise NoMethodError
      end

      def bearer_token
        raise NoMethodError
      end

      def get_token
        raise NoMethodError
      end

      def get_patient_record(id)
        response_body = fetch_patient_url(id)
        get_required_fields(JSON.parse(response_body))
      end

      def fetch_patient_url(id)
        # Normally, could also use the uri and then uri.hostname and uri.port
        http = Net::HTTP.new(hostname, port)
        req = Net::HTTP::Get.new(patient_url + id.to_s)
        # Add the Bearer Token (fetched once) in the header of all requests.
        req["Authorization"] = "Bearer #{self.class.bearer_token}"
        req["Content-Type"] = "application/json"
        response = http.request(req)
        return unless response.is_a?(Net::HTTPSuccess)
        response.body
      end

      def get_required_fields(params)
        raise NoMethodError
      end
    end
  end
end
