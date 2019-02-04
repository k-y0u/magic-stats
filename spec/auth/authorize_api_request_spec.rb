require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  let(:user) { create(:user) }
  subject(:request_obj) { described_class.new(valid_headers) }
  subject(:invalid_request_obj) { described_class.new(invalid_headers) }

  # Test Suite for AuthorizeApiRequest#call
  describe '#call' do

    # Returns user object when request is valid
    context 'when valid request' do
      it 'returns user object' do
        result = request_obj.call
        expect(result[:user]).to eq(user)
      end
    end

    # Returns error message when invalid request
    context 'when invalid request' do
      context 'when missing token' do
        it 'raises a MissingToken erro' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::MissingToken, /Missing token/)
        end
      end

      context 'when invalid token' do
        subject(:invalid_request_obj) do
          described_class.new('Authorization' => token_generator(5))
        end

        it 'raises an InvalidToken error' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
        end
      end

      context 'when token is expired' do
        let(:expired_headers) { { 'Authorization' => expired_token_generator(user.id) } }
        subject(:request_obj) { described_class.new(expired_headers) }

        it 'raises ExceptionHandler::ExpiredSignature error' do
          expect { request_obj.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Signature has expired/)
        end
      end

      context 'when token is fake' do
        let(:fake_headers) { { 'Authorization' => 'foobar' } }
        subject(:invalid_request_obj) { described_class.new(fake_headers)}

        it 'handles JWT::DecodeError' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Not enough or too many segments/)
        end
      end
    end
  end
end
