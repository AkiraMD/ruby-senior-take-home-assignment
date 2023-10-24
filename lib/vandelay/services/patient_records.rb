require_relative '../integrations/services/vendor_one'
require_relative '../integrations/services/vendor_two'

module Vandelay
  module Services
    class PatientRecords
      def initialize
        super

        @vendor_one = Vandelay::Integrations::Services::VendorOne.new
        @vendor_two = Vandelay::Integrations::Services::VendorTwo.new
      end

      # @param [Vandelay::Models::Patient] patient
      # @return [Vandelay::Integrations::Models::VendorRecordResult]
      def retrieve_record_for_patient(patient)
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