require 'vandelay/util/db'

module Vandelay
  module Services
    class Patients
      def retrieve_all
        Vandelay::Util::DB.with_default_connection do |conn|
          conn.exec("SELECT * FROM patients").to_a
        end
      end

      def retrieve_one(patient_id)
        Vandelay::Util::DB.with_default_connection do |conn|
          conn.exec("SELECT * FROM patients WHERE id = '#{patient_id}' LIMIT 1").to_a[0]
        end
      end
    end
  end
end
