# frozen_string_literal: true

RSpec.describe "GET /patients" do
  subject(:response) { get '/patients' }
  subject(:json_response) { JSON.parse(response.body) }

  context 'no patients present' do
    it { expect(response).to be_ok }
    it { expect(json_response).to be_empty }
  end

  context 'two patients present' do
    let!(:patients) do
      [
        create(:patient),
        create(:patient)
      ]
    end

    it { expect(json_response.count).to eq 2 }

    it 'returns patient details' do
      expect(json_response).to include(JSON.parse(patients[0].to_h.to_json))
      expect(json_response).to include(JSON.parse(patients[1].to_h.to_json))
    end
  end
end