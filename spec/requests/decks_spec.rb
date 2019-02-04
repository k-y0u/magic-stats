require 'rails_helper'

RSpec.describe 'Deck API', type: :request do
  let!(:user) { create(:user) }
  let!(:decks) { create_list(:deck, 10, user_id: user.id) }
  let(:user_id) { user.id }
  let(:deck_id) { decks.first.id }
  let(:headers) { valid_headers }

  # Test suite for GET /users/:user_id/decks
  describe 'GET /users/:user_id/decks' do
    before { get "/users/#{user_id}/decks", params: {}, headers: headers }

    context 'when user exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all user decks' do
        expect(json.size).to eq(10)
      end
    end

    context 'when user does not exists' do
      let(:user_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  # Test suite for GET /users/:user_id/decks/:deck_id
  describe 'GET /users/:user_id/decks/:deck_id' do
    before { get "/users/#{user_id}/decks/#{deck_id}", params: {}, headers: headers }

    context 'when user deck exists' do
      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the deck' do
        expect(json['id']).to eq(deck_id)
      end
    end

    context 'when user deck does not exists' do
      let(:deck_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Deck/)
      end
    end
  end

  # Test suite for POST /users/:user_id/decks
  describe 'POST /users/:user_id/decks' do
    let(:valid_attributes) { { name: 'DeckOnFire', description: 'This deck is about fire.' } }

    context 'when request attributes are valid' do
      before { post "/users/#{user_id}/decks", params: valid_attributes.to_json, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request is invalid' do
      before { post "/users/#{user_id}/decks", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /users/:user_id/decks/:deck_id
  describe 'PUT /users/:user_id/decks/:deck_id' do
    let(:valid_attributes) { { name: 'Mario' } }

    before { put "/users/#{user_id}/decks/#{deck_id}", params: valid_attributes.to_json, headers: headers }

    context 'when deck exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the deck' do
        updated_deck = Deck.find(deck_id)
        expect(updated_deck.name).to match(/Mario/)
      end
    end

    context 'when the deck does not exists' do
      let(:deck_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Deck/)
      end
    end
  end

  # Test suite for DELETE /users/:user_id/decks/:deck_id
  describe 'DELETE /users/:user_id/decks/:deck_id' do
    before { delete "/users/#{user_id}/decks/#{deck_id}", params: {}, headers: headers }

    context 'when the deck exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end
