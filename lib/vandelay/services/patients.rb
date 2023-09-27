require 'vandelay/models/patient'

module Vandelay
  module Services
    class Patients
      def retrieve_all
        Vandelay::Models::Patient.all
      end

      def retrieve_one(patient_id)
        Vandelay::Models::Patient.with_id(patient_id)
      end
    end
  end
end
