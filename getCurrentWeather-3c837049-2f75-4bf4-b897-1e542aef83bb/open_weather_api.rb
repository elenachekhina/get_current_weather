require 'net/http'
require 'uri'
require 'aws_secretmanager'

$direction = %w[N NE E SE S SW W NW]
$api_key = get_secret('openweathermap')

def get_api_weather(city)
  url = URI.parse("https://api.openweathermap.org/data/2.5/weather?q=#{city}&units=metric&appid=#{$api_key}")
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(url.request_uri)

  process_response(http.request(request))
end

def process_response(response)
  body = JSON.parse(response.body)
  if response.code == '404'
    return body['message'].to_json
  end

  {
    city: body['name'],
    temperature: body['main']['temp'],
    weatherCondition: {
      type: body['weather'][0]['main'],
      pressure: body['main']['pressure'],
      humidity: body['main']['humidity']
    },
    wind: {
      speed: body['wind']['speed'],
      direction: $direction[(body['wind']['deg'] / 45) % 8]
    }
  }.to_json
end