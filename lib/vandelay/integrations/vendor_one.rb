require_relative 'vendor_common'

module Vandelay
  module Integrations
    class VendorOne
      def fetch_patient_record(vendor_id)
        VendorCommon.fetch_patient_record('one', "/patients/#{vendor_id}")
      end
    end
  end
end
