module Vandelay
  module Integrations
    class Base
      def self.new(*)
        return super unless self == Vandelay::Integrations::Base
    
        raise 'Cannot instantiate abstract class'
      end
    
      def get_patient_information(patient_vendor_id)
        token = authenticate
        return nil unless token

        headers = { 'Authorization' => "Bearer #{token}" }
        json_data = Vandelay::Util::Cache.fetch("#{self.class.name.downcase}_patients_info") do # Default expiration is 10 minutes
          response = send_request(source_records_endpoint, headers)
          return nil unless response
  
          response.body
        end
        return nil unless json_data

        patient_records = JSON.parse(json_data)
        patient = find_patient(patient_records, patient_vendor_id)
        return patient_information(patient) if patient

        nil # Patient not found
      end

      protected

      def patient_information(patient)
        raise NotImplementedError.new('You must implement #patient_information on child class')
      end

      def authentication_endpoint
        raise NotImplementedError.new('You must implement #authentication_endpoint on child class')
      end

      def source_records_endpoint
        raise NotImplementedError.new('You must implement #source_records_endpoint on child class')
      end

      def token_param_name
        raise NotImplementedError.new('You must implement #token_param_name on child class')
      end

      private

      def send_request(url, headers = {})
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme == 'https'

        request = Net::HTTP::Get.new(uri)
        headers.each { |key, value| request[key] = value }

        response = http.request(request)
        response if response.is_a?(Net::HTTPSuccess)
      rescue StandardError => e
        puts "Error: #{e.message}"
        nil
      end

      def authenticate
        response = send_request(authentication_endpoint)
        return nil unless response

        token = JSON.parse(response.body)[token_param_name]
        token
      end

      def find_patient(patient_records, patient_id)
        patient_records.each do |patient|
          return patient if patient['id'].to_i == patient_id.to_i
        end
        nil
      end
    end
  end
end
