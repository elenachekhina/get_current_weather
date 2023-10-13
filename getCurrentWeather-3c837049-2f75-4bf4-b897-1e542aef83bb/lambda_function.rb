require 'open_weather_api'
require 'redis_cache'

def get_weather_data(city)
  cached_wether = get_cached_wether(city)
  
  if cached_wether
    return cached_wether
  else
    weather_data = get_api_weather(city)
    cache_weather(city, weather_data)
    return weather_data
  end
end
  
def lambda_handler(event:, context:)
  city = event['queryStringParameters']['city']
  
  weather_data = get_weather_data(city)
  
  if weather_data
    { statusCode: 200, body: weather_data }
  else
    { statusCode: 404, body: "Smth went wrong" }
  end
end
