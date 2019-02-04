require 'rails_helper'

RSpec.describe 'User API', type: :request do
  # Initialize test data
  let!(:users) { create_list(:user, 10) }
  let(:user) { users.first }
  let(:user_id) { user.id }
  let(:headers) { valid_headers }

  # Test suite for GET /users
  describe 'GET /users' do
    # Make  HTTP get request before each example
    before { get '/users', params: {}, headers: headers }

    it 'returns users' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /users/:id
  describe 'GET /users/:id' do
    before { get "/users/#{user_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:user_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  # Test suite for POST /users
  describe 'POST /users' do
    let(:valid_attributes) { { name: 'Mario', password: 'password', password_confirmation: 'password' } }

    context 'when the request is valid' do
      before { post '/users', params: valid_attributes.to_json, headers: headers }

      it 'creates a user' do
        expect(json['user']['name']).to eq('Mario')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/users', params: { }.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Password can't be blank, Name can't be blank, Password digest can't be blank/)
      end
    end
  end

  # Test suite for POST /users
  describe 'POST /users' do
    let(:user) { build(:user) }
    let(:headers) { valid_headers.except('Auhtaurization') }
    let(:valid_attributes) do
      attributes_for(:user, password_confirmation: user.password)
    end

    context 'when valid request' do
      before { post '/users', params: valid_attributes.to_json, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { post '/users', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json['message']).to match(/Validation failed: Password can't be blank, Name can't be blank, Password digest can't be blank/)
      end
    end
  end

  # Test suite for PUT /users/:id
  describe 'PUT /users/:id' do
    let(:valid_attributes) { { name: 'Luigi' } }

    context 'when the record exists' do
      before { put "/users/#{user_id}", params: valid_attributes.to_json, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /users/:id
  describe 'DELETE /users/:id' do
    before { delete "/users/#{user_id}", params: {}, headers: headers }

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
