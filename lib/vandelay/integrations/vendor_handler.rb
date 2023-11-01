require 'yaml'
require 'rest-client'

module Vandelay
  module Integrations
      class VendorHandler
        def self.get_vendor_one_patient_data(vendor_patient_id)
          url = self.base_api_url("one")
          auth_token = self.get_vendor_one_auth_token(url)

          return self.get_api_request(url+"/patients/#{vendor_patient_id}", auth_token)
        end

        def self.get_vendor_two_patient_data(vendor_patient_id)
          url = self.base_api_url("two")
          auth_token = self.get_vendor_two_auth_token(url)

          return self.get_api_request(url+"/records/#{vendor_patient_id}", auth_token)
        end

        private

          def self.base_api_url(vendor)
            YAML.safe_load(File.read('config.dev.yml'))['integrations']['vendors'][vendor]['api_base_url']
          end

          def self.get_vendor_one_auth_token(url)
            JSON.parse(RestClient.get(url+"/auth/1"))["token"]
          end

          def self.get_vendor_two_auth_token(url)
            JSON.parse(RestClient.get(url+"/auth_tokens/1"))["auth_token"]
          end

          def self.get_api_request(url, auth_token)
            begin
              JSON.parse(RestClient::Request.execute(
                :method => "get",
                :url => url,
                :headers => {"authorization" => "Bearer #{auth_token}"}
              ))
            rescue RestClient::Exception => e
              {"error" => e.to_s}
            end
          end
      end
  end
end