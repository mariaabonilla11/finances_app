require 'rails_helper'
require './spec/support/request_helpers'


RSpec.describe "POST /auth/refresh", type: :request do
  let(:url) { '/auth/refresh' }
  let(:user) { create(:user, password: 'password123', state: :active) }
  let(:inactive_user) { create(:user, password: 'password123', state: :inactive) }
  let(:valid_token) { generate_token(user) }
  let(:refresh_token) { generate_refresh_token(user) }
  let(:refresh_token_expired) { generate_refresh_token_expired(user) }
  let(:refresh_token_user_inactivate) { generate_refresh_token(inactive_user) }
  def auth_post(params = {})
    post url, params: params
  end

  context "with valid refresh token" do
    it "gets token successfully" do
      auth_post({ 'refresh_token': refresh_token })

      expect(response).to have_http_status(:ok)
      expect(json_response['success']).to be true
      expect(json_response['token']).to be_present

      new_token = json_response['token']
      expect(JwtServices::TokenManagerService.expired?(new_token)).to be false
    end
    it "returns complete response structure" do
      auth_post({ refresh_token: refresh_token })

      expect(json_response).to include(
        'success' => true,
        'token' => be_present,
        'exp' => be_present
      )
    end
  end

  context "with invalid refresh token" do
    it "if refresh token is expired" do 
      auth_post({ 'refresh_token': refresh_token_expired })
      expect(response).to have_http_status(:unauthorized)
      expect(json_response['success']).to be false
      expect(json_response['message']).to include('Refresh token inválido o expirado')
      expect(JwtServices::RefreshToken.expired?(refresh_token_expired)).to be true
    end

    it "if not send param refresh token" do 
      post url, as: :json 
      expect(response).to have_http_status(:unauthorized)
      expect(json_response['success']).to be false
      expect(json_response['message']).to include('Refresh token no proporcionado')
    end

    it "if inactive user" do 
      auth_post({ 'refresh_token': refresh_token_user_inactivate })
      expect(response).to have_http_status(:unauthorized)
      expect(json_response['success']).to be false
      expect(json_response['message']).to include('Refresh token inválido, usuario inactivo')
    end
  end

  context "when refresh token format is invalid" do
      shared_examples "invalid token format" do |token_value|
        it "rejects token: #{token_value.inspect}" do
          auth_post({ refresh_token: token_value })

          expect(response).to have_http_status(:unauthorized)
          expect(json_response['success']).to be false
        end
      end

      include_examples "invalid token format", "d34sh3"
      include_examples "invalid token format", ""
      include_examples "invalid token format", "   " 
      include_examples "invalid token format", nil
  end
end