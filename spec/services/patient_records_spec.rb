
RSpec.describe Vandelay::Services::PatientRecords do
  let(:patient_service) { Vandelay::Services::Patients.new }
  let(:service) { described_class.new }

  it 'loads a patient by id' do
    patient = patient_service.retrieve_one(2)
    record = service.retrieve_record_for_patient(patient)
    expect(record["patient_id"]).to eq("743")
    expect(record["province"]).to eq("QC")
    expect(record["num_medical_visits"]).to eq(1)
  end
end
