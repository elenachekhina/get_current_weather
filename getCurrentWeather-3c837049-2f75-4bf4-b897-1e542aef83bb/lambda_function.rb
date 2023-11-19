require_relative 'open_weather_api'
require_relative 'redis_cache'

def get_weather_data(city)
  cached_wether = get_cached_wether(city)

  return cached_wether if cached_wether

  weather_data = get_api_weather(city)
  cache_weather(city, weather_data)
  weather_data
end

def lambda_handler(event:, context:)
  city = event['queryStringParameters']['city']

  weather_data = get_weather_data(city)

  if weather_data
    { statusCode: 200, body: weather_data }
  else
    { statusCode: 404, body: 'Something went wrong' }
  end
end
