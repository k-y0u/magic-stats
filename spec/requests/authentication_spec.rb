require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  # Authentication test suite
  describe 'POST auth/login' do
    let!(:user) { create(:user) }
    let(:headers) { valid_headers.except('Authorization') }
    let(:valid_credentials) do
      {
        name: user.name,
        password: user.password
      }.to_json
    end
    let(:invalid_credentials) do
      {
        name: Faker::Pokemon.name,
        password: Faker::SiliconValley.company
      }.to_json
    end

    context 'When request is valid' do
      before { post '/auth/login', params: valid_credentials, headers: headers }

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'When request is invalid' do
      before { post '/auth/login', params: invalid_credentials, headers: headers }

      it 'returns a failure message' do
        expect(json['message']).to match(/Invalid credentials/)
      end
    end
  end
end
