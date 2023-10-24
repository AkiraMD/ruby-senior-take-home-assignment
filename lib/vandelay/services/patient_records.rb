require_relative '../integrations/services/vendor_one'

module Vandelay
  module Services
    class PatientRecords
      def initialize
        super

        @vendor_one = Vandelay::Integrations::Services::VendorOne.new
      end

        # @param [Vandelay::Models::Patient] patient
      # @return [Vandelay::Integrations::Models::VendorRecordResult]
      def retrieve_record_for_patient(patient)
        raise 'Unsupported vendor' unless patient.records_vendor == 'one'

        @vendor_one.retrieve_record_for_patient patient.vendor_id
      end
    end
  end
end