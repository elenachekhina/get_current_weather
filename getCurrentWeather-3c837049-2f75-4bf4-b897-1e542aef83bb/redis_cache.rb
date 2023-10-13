require 'redis'

host='openweather-api-cache-0001-001.y9rapy.0001.use1.cache.amazonaws.com'
port=6379
$redis = Redis.new(host: host, port: port)

def get_cached_wether(city)
  $redis.get(city)
end

def cache_weather(city, weather_data)
  $redis.set(city, weather_data, ex: 60)
end
