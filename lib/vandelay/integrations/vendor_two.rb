require_relative 'vendor_common'

module Vandelay
  module Integrations
    class VendorTwo
      def fetch_patient_record(vendor_id)
        VendorCommon.fetch_patient_record('two', "/records/#{vendor_id}")
      end
    end
  end
end
