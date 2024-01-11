module Vandelay
  module Integrations
    module VendorOne
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
          API_V1_HOST = ENV["VENDOR_ONE_API_V1_HOST"] || "http:://localhost:3060"
          GET_RECORD_PATH = "/patients/"
          AUTH_PATH = "/auth/1"
          PORT = 3060          

          private_constant :API_V1_HOST, :GET_RECORD_PATH, :AUTH_PATH, :PORT

          def patient_url
            #"#{API_V1_HOST}#{GET_RECORD_PATH}"
            GET_RECORD_PATH
          end

          def hostname
            "host.docker.internal"
          end

          def port
            PORT
          end

          def get_token
            http = Net::HTTP.new(hostname, port)
            req = Net::HTTP::Get.new(AUTH_PATH)      
            response = http.request(req)
            return unless response.is_a?(Net::HTTPSuccess)
            JSON.parse(response.body)["token"]
          end

          def get_required_fields(params)
            {
              "patient_id": params["id"],
              "province": params["province"],
              "allergies": params["allergies"],
              "num_medical_visits": params["recent_medical_visits"]
            }
          end
        end
      end
    end
  end
end
