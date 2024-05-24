require 'net/http'

module Vandelay
  module Integrations
    class ApiClientBase
      def api_base_url
        'http://' + Vandelay.config.dig('integrations', 'vendors', config_name, 'api_base_url')
      end

      def get_patient_record(patient_id)
        uri = URI.parse(resource_url)
        http = Net::HTTP.new(uri.host, uri.port)

        request = Net::HTTP::Get.new("#{resource_url}/#{patient_id}")
        request['Authorization'] = "Bearer #{get_token}"
        request['Content-Type'] = 'application/json'

        response = http.request(request)
        JSON.parse(response.body)
      end

      def get_token
        uri = URI.parse(token_url)
        http = Net::HTTP.new(uri.host, uri.port)

        request = Net::HTTP::Get.new(token_url)
        request['Content-Type'] = 'application/json'

        response = http.request(request)
        JSON.parse(response.body)[token_name]
      end
    end
  end
end
