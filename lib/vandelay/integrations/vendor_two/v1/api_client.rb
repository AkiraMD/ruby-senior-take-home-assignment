module Vandelay
  module Integrations
    module VendorTwo
      module V1
        class ApiClient < Vandelay::Integrations::Base
          class << self
            attr_accessor :bearer_token
          end
        
          @bearer_token = nil
        
          def initialize
            self.class.bearer_token ||= get_token
          end

          # These can be stored in ENV or config 
          # Normally, just the host url would be enough, and can use uri.hostname and uri.port
          API_V1_HOST = ENV["VENDOR_TWO_API_V1_HOST"] || "http:://localhost:3061"
          GET_RECORD_PATH = "/records/"
          AUTH_PATH = "/auth_tokens/1"
          PORT = 3061

          private_constant :API_V1_HOST, :GET_RECORD_PATH, :AUTH_PATH, :PORT

          def port
            PORT
          end

          def hostname
            # instead of localhost so that it will work with docker.
            "host.docker.internal"
          end

          def patient_url
            #"#{API_V1_HOST}#{GET_RECORD_PATH}"
            GET_RECORD_PATH
          end


          def get_token
            http = Net::HTTP.new(hostname, port)
            req = Net::HTTP::Get.new(AUTH_PATH)   
            response = http.request(req)
            return unless response.is_a?(Net::HTTPSuccess)
            JSON.parse(response.body)["auth_token"]
          end

          def get_required_fields(params)
            {
              "patient_id": params["id"],
              "province": params["province_code"],
              "allergies": params["allergies_list"],
              "num_medical_visits": params["medical_visits_recently"]
            }
          end
        end
      end
    end
  end
end
