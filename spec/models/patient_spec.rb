RSpec.describe Vandelay::Models::Patient do

  it 'loads all patients' do
    patients = described_class.all
    expect(patients.count).to eq(3)
    expect(patients.map{|x| x.vendor_id}.compact.sort).to eq(["16", "743"])
  end

  it 'loads a patient by id' do
    patient = described_class.with_id(1)
    expect(patient.id).to eq("1")
  end
end
