RSpec.describe Vandelay::Services::PatientRecords, type: :service do
  describe '#retrieve_record_for_patient' do
    subject { described_class.new.retrieve_record_for_patient(patient) }

    let(:patient) { Vandelay::Models::Patient.with_id(patient_id) }

    context 'when patient has no vendor' do
      let(:patient_id) { 1 }

      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'when patient has vendor one' do
      let(:patient_id) { 2 }

      it 'calls the correct vendor api client' do
        expect(subject).to eq({
          patient_id: '2',
          province: 'QC',
          allergies: ['work', 'conformity', 'paying taxes'],
          num_medical_visits: 1
        })
      end
    end

    context 'when patient has vendor two' do
      let(:patient_id) { 3 }

      it 'calls the correct vendor api client' do
        expect(subject).to eq({
          patient_id: '3',
          province: 'ON',
          allergies: ['hair', 'mean people', 'paying the bill'],
          num_medical_visits: 17
        })
      end
    end
  end
end
