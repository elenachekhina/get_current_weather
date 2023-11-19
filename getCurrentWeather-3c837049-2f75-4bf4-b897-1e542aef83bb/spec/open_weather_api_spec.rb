require 'spec_helper'
require 'aws-sdk-secretsmanager'

RSpec.describe 'Open Weather API' do
  before do
    client = Aws::SecretsManager::Client.new(stub_responses: true)
    client.stub_responses(:get_secret_value, secret_string: { 'openweathermap' => 'openweathermap_secret_key' }.to_json)
    allow(Aws::SecretsManager::Client).to receive(:new).and_return(client)

    require_relative '../open_weather_api'
  end

  describe 'get_api_weather' do
    before do
      stub_request(:get, /api.openweathermap.org/)
        .to_return(status: 200, body: {
          'name' => 'New York',
          'main' => { 'temp' => 15.5, 'pressure' => 1012, 'humidity' => 60 },
          'weather' => [{ 'main' => 'Cloudy' }],
          'wind' => { 'speed' => 5.5, 'deg' => 90 }
        }.to_json)
    end

    it 'returns the correct weather data' do
      result = JSON.parse(get_api_weather('New York'))
      expect(result['city']).to eq('New York')
    end

  end

  describe 'process_response' do
    let(:success_response) {
      double('response',
             body: {
               'name' => 'New York',
               'main' => { 'temp' => 15.5, 'pressure' => 1012, 'humidity' => 60 },
               'weather' => [{ 'main' => 'Cloudy' }],
               'wind' => { 'speed' => 5.5, 'deg' => 90 }
             }.to_json,
             code: '200'
      )
    }

    let(:not_found_response) {
      double('response',
             body: { 'message' => 'City not found' }.to_json,
             code: '404'
      )
    }

    context 'when the response code is 200' do
      it 'returns the correct weather data' do
        result = JSON.parse(process_response(success_response))
        expect(result['city']).to eq('New York')
      end
    end

    context 'when the response code is 404' do
      it 'returns the error message' do
        result = JSON.parse(process_response(not_found_response))
        expect(result).to eq('City not found')
      end
    end
  end
end
