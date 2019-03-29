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
    let(:headers) { valid_headers.except('Auhtaurization') }
    let(:valid_attributes) { { name: 'Mario', password: 'password', password_confirmation: 'password' } }
    let(:wrong_format_attributes) { { name: 'Mario', password: 'pass word', password_confirmation: 'pass word' } }
    let(:too_long_string) { [*'a'..'z', *'A'..'Z', *0..9].shuffle[0, 43].join }
    let(:too_long_attributes) { { name: too_long_string , password: too_long_string, password_confirmation: too_long_string } }
    let(:too_short_attributes) { { name: 'Bi' , password: 'azertyu', password_confirmation: 'azertyu' } }
    let(:not_unique_attributes) { { name: user.name, password: 'password', password_confirmation: 'password' } }
    let(:wrong_confirmation_attributes) { { name: 'Luigi', password: 'password', password_confirmation: 'passwword' } }

    context 'when the request is valid' do
      before { post '/users', params: valid_attributes.to_json, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when the attributes are missing' do
      before { post '/users', params: { }.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed/)
        expect(response.body).to match(/Password can't be blank/)
        expect(response.body).to match(/Password confirmation can't be blank/)
        expect(response.body).to match(/Password digest can't be blank/)
        expect(response.body).to match(/Name can't be blank/)
      end

      it 'returns an authentication token nil' do
        expect(json['auth_token']).to be_nil
      end
    end

    context 'when passowrd attribute contain a forbidden character' do
      before { post '/users', params: wrong_format_attributes.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed/)
        expect(response.body).to match(/Password should not contain whitespace character/)
      end
    end

    context 'when the attributes are too long' do
      before { post '/users', params: too_long_attributes.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed/)
        expect(response.body).to match(/Password is too long/)
        expect(response.body).to match(/Name is too long/)
      end
    end

    context 'when the attributes are too short' do
      before { post '/users', params: too_short_attributes.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed/)
        expect(response.body).to match(/Password is too short/)
        expect(response.body).to match(/Name is too short/)
      end
    end

    context 'when name attribute is not unique' do
      before { post '/users', params: not_unique_attributes.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed/)
        expect(response.body).to match(/Name has already been taken/)
      end
    end

    context 'when password_confirmation attribute is not equal to password attribute' do
      before { post '/users', params: wrong_confirmation_attributes.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed/)
        expect(response.body).to match(/Password confirmation doesn't match Password/)
      end
    end
  end

  # Test suite for PUT /users/:id
  describe 'PUT /users/:id' do
    let(:valid_attributes) { { name: 'Luigi' } }

    context 'when the record matches authenticated user' do
      before { put "/users/#{user_id}", params: valid_attributes.to_json, headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the record' do
        expect(response.body).to be_empty
      end
    end

    context 'when the record does not match authenticate user' do
      before { put "/users/#{users[2].id}", params: valid_attributes.to_json, headers: headers }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Invalid user account/)
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
