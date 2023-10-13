require 'aws-sdk-secretsmanager'

def get_secret(secret_key)
  client = Aws::SecretsManager::Client.new(region: 'us-east-1')
  
  begin
    get_secret_value_response = client.get_secret_value(secret_id: 'dev/getCurrentWeather/OpenWeatherMap')
  rescue StandardError => e
    raise e
  end

  secret = JSON.parse(get_secret_value_response.secret_string)[secret_key]
end
