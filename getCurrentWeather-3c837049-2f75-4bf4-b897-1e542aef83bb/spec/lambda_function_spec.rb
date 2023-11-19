require 'spec_helper'
require 'aws-sdk-secretsmanager'
require 'redis'

RSpec.describe 'Lambda' do
  before do
    client = Aws::SecretsManager::Client.new(stub_responses: true)
    client.stub_responses(:get_secret_value, secret_string: { 'openweathermap' => 'openweathermap_secret_key' }.to_json)
    allow(Aws::SecretsManager::Client).to receive(:new).and_return(client)

    redis = Redis.new
    allow(Redis).to receive(:new).and_return(redis)

    require_relative '../lambda_function'
  end

  describe 'lambda_handler' do
    let(:success_event) do
      {
        'queryStringParameters' => {
          'city' => 'New York'
        }
      }
    end

    let(:not_found_event) do
      {
        'queryStringParameters' => {
          'city' => 'City'
        }
      }
    end

    let(:success_response) do
      {
        statusCode: 200,
        body: {
          'city' => 'New York',
          'temperature' => 15.5,
          'weatherCondition' => {
            'type' => 'Cloudy',
            'pressure' => 1012,
            'humidity' => 60
          },
          'wind' => {
            'speed' => 5.5,
            'direction' => 'E'
          }
        }.to_json
      }
    end

    let(:not_found_response) do
      {
        statusCode: 200,
        body: 'City not found'.to_json
      }
    end

    context 'when the city is found' do
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
        expect(lambda_handler(event: success_event, context: nil)).to eq(success_response)
      end
    end

    context 'when the city is not found' do
      before do
        stub_request(:get, /api.openweathermap.org/)
          .to_return(status: 404, body: { 'message' => 'City not found' }.to_json)
      end

      it 'returns the correct error message' do
        expect(lambda_handler(event: not_found_event, context: nil)).to eq(not_found_response)
      end
    end
  end

  describe 'get_weather_data' do
    let(:city) { 'New York' }
    let(:weather_data) { 'weather data' }
    let(:cached_weather_data) { 'cached weather data' }

    context 'when the weather data is cached' do
      before do
        allow(self).to receive(:get_cached_wether).with(city).and_return(cached_weather_data)
      end

      it 'returns the cached weather data' do
        expect(get_weather_data(city)).to eq(cached_weather_data)
      end
    end

    context 'when the weather data is not cached' do
      before do
        allow(self).to receive(:get_cached_wether).with(city).and_return(nil)
        allow(self).to receive(:get_api_weather).with(city).and_return(weather_data)
        allow(self).to receive(:cache_weather).with(city, weather_data)
      end

      it 'returns the weather data from the API' do
        expect(get_weather_data(city)).to eq(weather_data)
      end

      it 'caches the weather data' do
        get_weather_data(city)
        expect(self).to have_received(:cache_weather).with(city, weather_data)
      end
    end
  end
end
