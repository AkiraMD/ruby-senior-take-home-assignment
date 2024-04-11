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
          conn.exec_params("SELECT * FROM patients WHERE id = $1::integer", [ patient_id ]).to_a
        end
      
        result.map do |patient_hash|
          Vandelay::Models::Patient.new(**patient_hash)
        end

      end

      def self.find_patient_record(patient_id)
        result = self.with_connection do |conn|
          conn.exec_params("SELECT p.*, r.id AS record_id, r.title, r.visit_number
                            FROM patients p
                            JOIN records r ON p.id = r.patient_id
                            WHERE p.id = $1::integer", [patient_id]).to_a
        end
        if result.any?
          Vandelay::Models::PatientRecord.new(**result)
        else
          nil  
        end
      end


    end
  end
end
