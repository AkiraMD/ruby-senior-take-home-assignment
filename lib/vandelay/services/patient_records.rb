require_relative '../integrations/services/vendor_one'
require_relative '../integrations/services/vendor_two'
require_relative '../util/cache'

module Vandelay
  module Services
    class PatientRecords
      def initialize
        super

        @vendor_one = Vandelay::Integrations::Services::VendorOne.new
        @vendor_two = Vandelay::Integrations::Services::VendorTwo.new
        @cache = Vandelay::Util::Cache.new 10
      end

      # @param [Vandelay::Models::Patient] patient
      # @return [Vandelay::Integrations::Models::VendorRecordResult]
      def retrieve_record_for_patient(patient)
        cached_record = @cache[patient.id]

        return cached_record unless cached_record.nil?

        fresh_record = fetch_record_from_api patient
        @cache[patient.id] = fresh_record unless fresh_record.unexpected_error?
        fresh_record
      end

      private

      # @param [Vandelay::Models::Patient] patient
      # @return [Vandelay::Integrations::Models::VendorRecordResult]
      def fetch_record_from_api(patient)
        case patient.records_vendor
        when 'one'
          @vendor_one.retrieve_record_for_patient patient.vendor_id
        when 'two'
          @vendor_two.retrieve_record_for_patient patient.vendor_id
        else
          raise 'Unsupported vendor'
        end
      end
    end
  end
end