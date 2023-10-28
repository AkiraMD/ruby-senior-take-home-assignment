module Vandelay
  module Models
    class PatientRecord < Vandelay::Models::Base
      REQUIRED_ATTRIBUTES = [
        :allergies,
        :num_medical_visits,
        :patient_id,
        :province
      ]

      def initialize(**data)
        super
        raise ArgumentError unless data.keys.sort == REQUIRED_ATTRIBUTES
      end
    end
  end
end
