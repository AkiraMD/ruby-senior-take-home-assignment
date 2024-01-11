require 'spec_helper'

RSpec.describe Vandelay::Integrations::IntegrationOne, type: :integration do
  subject { described_class.new }

  it 'defines #get_patient_information' do
    expect(subject).to respond_to(:get_patient_information)
  end

  it '#get_patient_information returns nil when user does not exist' do
    expect(subject.get_patient_information(1)).to be_nil
  end

  it '#get_patient_information returns a valid hash when user exists' do
    # stub_request('http://mock_api_one:80/auth/1', {}, {
    #   'id': '1',
    #   'token': 'some-token'
    # })
    # stub_request('http://mock_api_one:80/patients', { 'Authorization': 'Bearer some-token' }, [
    #   {
    #     'id': '45',
    #     'full_name': 'Jerry Seinfeld',
    #     'dob': '1983-09-11',
    #     'province': 'BC',
    #     'allergies': ['peanuts'],
    #     'recent_medical_visits': '3'
    #   }
    # ])

    expect(subject.get_patient_information(743)).to match({
      province: 'QC',
      allergies: ['work', 'conformity', 'paying taxes'],
      num_medical_visits: 1
    })
  end

  # def stub_request(url, headers = {}, response = nil)
  #   uri = double('URI', host: 'mock_api_one', port: 80, scheme: 'http', request_uri: url, empty?: false)
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
