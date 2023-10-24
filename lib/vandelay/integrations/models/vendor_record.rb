# frozen_string_literal: true

class VendorRecord
  attr_accessor :province
  attr_accessor :allergies
  attr_accessor :num_medical_visits

  # @return [VendorRecord]
  def self.from_vendor_one_response(json_hash)
    record = VendorRecord.new
    record.province = json_hash[:province]
    record.allergies = json_hash[:allergies]
    record.num_medical_visits = json_hash[:recent_medical_visits]
    record
  end

  # @return [VendorRecord]
  def self.from_vendor_two_response(json_hash)
    record = VendorRecord.new
    record.province = json_hash[:province_code]
    record.allergies = json_hash[:allergies_list]
    record.num_medical_visits = json_hash[:medical_visits_recently]
    record
  end
end
