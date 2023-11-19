require 'spec_helper'
require 'redis'

RSpec.describe 'Weather Cache' do
  let(:city) { 'London' }
  let(:weather_data) { 'weather data' }

  before do
    redis = Redis.new
    allow(Redis).to receive(:new).and_return(redis)

    require_relative '../redis_cache'
  end

  describe 'get_cached_wether' do
    it 'should return weather data if cached' do
      $redis.set(city, weather_data)
      expect(get_cached_wether(city)).to eq(weather_data)
    end
  end

  describe 'cache_weather' do
    it 'should cache weather data' do
      cache_weather(city, weather_data)
      expect($redis.get(city)).to eq(weather_data)
    end
  end
end
