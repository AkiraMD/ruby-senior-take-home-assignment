require 'vandelay/integrations/no_vendor_service'
require 'vandelay/integrations/vendor1_service'
require 'vandelay/integrations/vendor2_service'

module Vandelay
  module Integrations
    class FactoryService

      def self.create(patient)
        vendor_name = patient.records_vendor || 'no_vendor'
        service_configuration = Vandelay.config.dig('integrations', 'vendors', vendor_name)
        url = service_configuration['api_base_url']
        service_clazz = Object.const_get("Vandelay::Integrations::#{service_configuration['service_class']}")
        service_clazz.new(patient, url)
      end
    end
  end
end
