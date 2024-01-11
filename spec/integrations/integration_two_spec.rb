require 'spec_helper'

RSpec.describe Vandelay::Integrations::IntegrationTwo, type: :integration do
  subject { described_class.new }

  it 'defines #get_patient_information' do
    expect(subject).to respond_to(:get_patient_information)
  end

  it '#get_patient_information returns nil when user does not exist' do
    expect(subject.get_patient_information(1)).to be_nil
  end

  it '#get_patient_information returns a valid hash when user exists' do
    # stub_request('http://mock_api_two:80/auth_tokens/1', {}, {
    #   'id': '1',
    #   'auth_token': 'some-token'
    # })
    # stub_request('http://mock_api_two:80/patients', { 'Authorization': 'Bearer some-token' }, [
    #   {
    #     'id': '45',
    #     'name': 'Mike Ross',
    #     'birthdate': '1981-08-01',
    #     'province_code': 'MB',
    #     'clinic_id': '11',
    #     'allergies_list': ['coconuts'],
    #     'medical_visits_recently': '3'
    #   }
    # ])

    expect(subject.get_patient_information(16)).to match({
      province: 'ON',
      allergies: ['hair', 'mean people', 'paying the bill'],
      num_medical_visits: 17
    })
  end

  # def stub_request(url, headers = {}, response = nil)
  #   uri = double('URI', host: 'mock_api_two', port: 80, scheme: 'http', request_uri: url, empty?: false)
  #   http = double('Http')
  #   get_request = double('GetRequest', :[]= => nil)

  #   allow(URI).to receive(:parse).with(url) { uri }
  #   expect_any_instance_of(Net::HTTP).to receive(:new) { http }
  #   expect_any_instance_of(Net::HTTP::Get).to receive(:new).with(uri) { get_request }
  #   expect(http).to receive(:request).with(get_request) do
  #     double('Response', is_a?: Net::HTTPSuccess, body: JSON.generate(response))
  #   end
  # end
end
