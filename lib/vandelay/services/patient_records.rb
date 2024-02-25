require 'vandelay/integrations/factory_service'

module Vandelay
  module Services
    class PatientRecords
      def retrieve_record_for_patient(patient)
        service = Vandelay::Integrations::FactoryService.create(patient)
        service.get_records_from_provider
      end
    end
  end
end
