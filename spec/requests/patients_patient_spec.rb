require 'spec_helper'
require 'vandelay/services/patient_records'
require 'vandelay/util/cache'
require 'vandelay/integrations/vendor_one'
require 'vandelay/integrations/vendor_two'

RSpec.describe Vandelay::Services::PatientRecords do
  let(:cache) { double('Vandelay::Util::Cache') }
  let(:patient_records) { described_class.new(patient) }

  before do
    allow(Vandelay::Util::Cache).to receive(:new).and_return(cache)
  end

  describe '#fetch_records with vendor one' do
    let(:patient) { double('Patient', id: 1, records_vendor: 'one', vendor_id: '743') }
    context 'when the record is cached' do
      it 'returns the cached record' do
        cached_record = {
          patient_id: 1,
          province: 'QC',
          allergies: ['work', 'conformity', 'paying taxes'],
          num_medical_visits: 1
        }.to_json
        allow(cache).to receive(:fetch).with("patient_records:1").and_return(cached_record)

        expect(patient_records.fetch_records).to eq(cached_record)
      end
    end

    context 'when the record is not cached' do
      it 'fetches the record and caches it' do
        record_to_fetch = {
          "allergies" => ["work", "conformity", "paying taxes"],
          "dob" => "1987-03-18",
          "full_name" => "Cosmo Kramer",
          "id" => "743",
          "province" => "QC",
          "recent_medical_visits" => 1,
        }

        allow(cache).to receive(:fetch).with("patient_records:1").and_yield
        expect(patient_records.fetch_records).to eq(record_to_fetch)
      end
    end

    context 'with invalid records_vendor' do
      let(:patient) { double('Patient', id: 1, records_vendor: 'invalid', vendor_id: '743') }

      it 'raises an error' do
        allow(cache).to receive(:fetch).with("patient_records:1").and_yield
        expect { patient_records.fetch_records }.to raise_error('Unknown vendor')
      end
    end
  end

  describe '#fetch_records with vendor two' do
    let(:patient) { double('Patient', id: 1, records_vendor: 'two', vendor_id: '16') }
    context 'when the record is cached' do
      it 'returns the cached record' do
        cached_record = {
          patient_id: 1,
          province: 'QC',
          allergies: ['work', 'conformity', 'paying taxes'],
          num_medical_visits: 1
        }.to_json
        allow(cache).to receive(:fetch).with("patient_records:1").and_return(cached_record)

        expect(patient_records.fetch_records).to eq(cached_record)
      end
    end

    context 'with invalid records_vendor' do
      let(:patient) { double('Patient', id: 1, records_vendor: 'invalid', vendor_id: '16') }

      it 'raises an error' do
        allow(cache).to receive(:fetch).with("patient_records:1").and_yield
        expect { patient_records.fetch_records }.to raise_error('Unknown vendor')
      end
    end
  end
end
