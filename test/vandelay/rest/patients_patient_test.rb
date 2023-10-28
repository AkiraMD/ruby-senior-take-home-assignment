require 'minitest/autorun'
require 'rack/test'
require_relative '../../../server'

class PatientsPatientTest < Minitest::Test
  include Rack::Test::Methods

  def app
    RESTServer
  end

  def test_patient_exists
    response = get '/patients/1'
    assert_equal response.status, Net::HTTPSuccess
    body = JSON.parse(response.body)
    assert_equal body['id'], 2
    assert_equal body['full_name'], 'Cosmo Kramer'
    assert_equal body['date_of_birth'], '1987-03-18'
    assert_equal body['records_vendor'], 'one'
    assert_equal body['vendor_id'], '743'
  end

  def test_patient_does_not_exist
    response = get '/patients/123'
    assert_equal response.status, Net::HTTPNotFound
  end
end
