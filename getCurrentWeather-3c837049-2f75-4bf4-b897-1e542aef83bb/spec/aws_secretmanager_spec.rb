require 'spec_helper'
require_relative '../aws_secretmanager'

RSpec.describe 'AWS Secret Manager' do
  before do
    client = Aws::SecretsManager::Client.new(stub_responses: true)
    client.stub_responses(:get_secret_value, secret_string: { 'stub_key' => 'stub_secret_key' }.to_json)

    allow(Aws::SecretsManager::Client).to receive(:new).and_return(client)
  end

  describe 'get_secret' do
    it 'returns the correct secret' do
      expect(get_secret('stub_key')).to eq('stub_secret_key')
    end
  end
end

