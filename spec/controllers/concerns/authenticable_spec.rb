require 'rails_helper'

RSpec.describe Authenticable, type: :controller do
  include RequestHelpers

  # Controller dummy para probar el concern
  controller(ApplicationController) do
    include Authenticable
    before_action :authorize_request

    def index
      render json: { success: true, user_email: current_user.email }
    end
  end

  let(:user) { create(:user, password: '123abc', state: :active) }
  let(:inactive_user) { create(:user, password: '123abc', state: :inactive) }
  let(:valid_token) { generate_token(user) }

  describe '#authorize_request' do
    context 'with valid token' do
      it 'allows access and sets current_user' do
        request.headers['Authorization'] = "Bearer #{valid_token}"
        get :index

        expect(response).to have_http_status(:ok)
        expect(json_response['success']).to be true
        expect(json_response['user_email']).to eq(user.email)
      end
    end

    context 'without  token' do
      it 'returns unauthorized error' do
        get :index
          expect(response).to have_http_status(:unauthorized)
          expect(json_response['success']).to be false
          expect(json_response['message']).to include('Token no proporcionado')
      end
    end

    context 'with invalid token' do
      it 'returns unauthorized error' do
        request.headers['Authorization'] = "Bearer sas2ss"
        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['success']).to be false
        expect(json_response['message']).to include('Token inválido o expirado')
      end
    end

    context 'with blacklisted token' do
      it 'returns token revoked error' do
        JwtServices::BlacklistService.add(valid_token)
        request.headers['Authorization'] = "Bearer #{valid_token}"
        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['message']).to include('Token revocado')
      end
    end

    context 'with inactive user' do
      it 'returns user inactive error' do
        inactive_token = generate_token(inactive_user)
        request.headers['Authorization'] = "Bearer #{inactive_token}"
        
        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['message']).to include('Usuario inactivo')
      end
    end

    context 'with non-existent user' do
      it 'returns user not found error' do
        deleted_user = create(:user, password: '1212ass')
        token = generate_token(deleted_user)
        deleted_user.destroy
        
        request.headers['Authorization'] = "Bearer #{token}"
        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['message']).to include('Usuario no encontrado')
      end
    end

    context 'with expired token' do
      it 'returns token expired error' do
        expired_token = generate_token_expired(user)
        request.headers['Authorization'] = "Bearer #{expired_token}"
        
        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['message']).to include('Token inválido o expirado')
      end
    end
  end

  describe '#current_user' do
    it 'returns nil before authentication' do
      expect(controller.send(:current_user)).to be_nil
    end

    it 'returns authenticated user after successful authorization' do
      request.headers['Authorization'] = "Bearer #{valid_token}"
      
      get :index
      
      expect(controller.send(:current_user)).to eq(user)
      expect(controller.send(:current_user)).to be_a(User)
    end
  end

  describe '#extract_token' do
    it 'extracts token from valid Authorization header' do
      token = 'abc123.def456.ghi789'
      request.headers['Authorization'] = "Bearer #{token}"
      
      expect(controller.send(:extract_token)).to eq(token)
    end

    it 'returns nil when Authorization header is missing' do
      expect(controller.send(:extract_token)).to be_nil
    end

    it 'handles empty Authorization header' do
      request.headers['Authorization'] = ""
      
      expect(controller.send(:extract_token)).to be_nil
    end
  end
end