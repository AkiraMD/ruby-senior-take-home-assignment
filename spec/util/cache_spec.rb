require './spec_helper'

RSpec.describe Vandelay::Util::Cache do
  let(:patient_one) { Vandelay::Models::Patient.with_id(1) }
  let(:patient_two) { Vandelay::Models::Patient.with_id(2) }

  describe 'Set and get cache data' do
    it 'it set and get patient details from cache cache' do
      set_cache = described_class.set_cached_data(patient_one.id, {id: patient_one.id , full_name: patient_one.full_name}.to_json)
      get_cache = described_class.get_cached_data(patient_one.id)
      parsed_response = JSON.parse(get_cache)
      expect(parsed_response["full_name"]).to eq patient_one.full_name
    end
  end
end
