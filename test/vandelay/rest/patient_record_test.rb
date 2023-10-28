require 'minitest/autorun'
require 'rack/test'
require_relative '../../../server'

class PatientsPatientTest < Minitest::Test
  include Rack::Test::Methods

  def app
    RESTServer
  end

  def test_patient_record_exists_vendor_one
    response = get '/patients/2/record'
    assert_equal response.status, Net::HTTPSuccess
    body = JSON.parse(response.body)
    assert_equal body['patient_id'], '2'
    assert_equal body['province'], 'QC'
    assert_equal body['allergies'], ['work', 'conformity', 'paying taxes']
    assert_equal body['num_medical_visits'], 1
  end

  def test_patient_record_exists_vendor_two
    response = get '/patients/3/record'
    assert_equal response.status, Net::HTTPSuccess
    body = JSON.parse(response.body)
    assert_equal body['patient_id'], '3'
    assert_equal body['province'], 'ON'
    assert_equal body['allergies'], ['hair', 'mean people', 'paying the bill']
    assert_equal body['num_medical_visits'], 17
  end

  def test_patient_record_dne
    response = get '/patients/1/record'
    assert_equal response.status, Net::HTTPNotFound
    assert_equal response.body, 'Vendor patient record not found'
  end

  def test_patient_dne
    response = get '/patients/123/record'
    assert_equal response.status, Net::HTTPNotFound
    assert_equal response.body, 'Patient not found'
  end
end
