
RSpec.describe Vandelay::Services::Patients do
  let(:service) { described_class.new }

  it 'loads all patients' do
    patients = service.retrieve_all
    expect(patients.count).to eq(3)
    expect(patients.map{|x| x.vendor_id}.compact.sort).to eq(["16", "743"])
  end

  it 'loads a patient by id' do
    patient = service.retrieve_one(1)
    expect(patient.id).to eq("1")
  end
end
