module Vandelay
  module Models
    class Patient < Vandelay::Models::Base

      def self.all
        results = self.with_connection do |conn|
          conn.exec("SELECT * FROM patients ORDER BY id").to_a
        end

        results.map do |patient_hash|
          Vandelay::Models::Patient.new(**patient_hash)
        end
      end

      def self.with_id(patient_id)
        result = self.with_connection do |conn|
          conn.exec_params("SELECT * FROM patients WHERE id = $1::integer", [ patient_id ]).to_a[0]
        end
        return nil if result.nil?

        Vandelay::Models::Patient.new(**result)
      end

    end
  end
end
