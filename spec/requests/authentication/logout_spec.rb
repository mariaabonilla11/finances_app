require 'rails_helper'
require './spec/support/request_helpers'


RSpec.describe "POST /auth/logout", type: :request do
  let(:url) { '/auth/logout' }
  let(:user) { create(:user, password: 'password123', state: :active) }
  let(:inactive_user) { create(:user, password: 'password123', state: :inactive) }
  let(:valid_token) { generate_token(user) }
  let(:inactive_user_token) { generate_token(inactive_user) }
  let(:expired_token) { generate_token_expired(user) }
  let(:refresh_token) { generate_refresh_token(user) }

  def auth_post(token, params = {})
    post url, headers: { 'Authorization' => "Bearer #{token}" }, params: params
  end

  context "with valid token" do
    it "logout successfully with valid token" do
      auth_post(valid_token)
      expect(response).to have_http_status(:ok)
      expect(json_response['success']).to be true
      expect(JwtServices::BlacklistService.blacklisted?(valid_token)).to be true
    end
    
    it "logout successfully with refresh_token" do
      auth_post(valid_token, { 'refresh_token': refresh_token })
      expect(response).to have_http_status(:ok)
      expect(json_response['success']).to be true
      expect(JwtServices::BlacklistService.blacklisted?(valid_token)).to be true
    end

    it "prevents using the token after logout" do
      token = valid_token
      auth_post(token)
      expect(response).to have_http_status(:ok)
      get '/auth/me', headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:unauthorized)
      expect(json_response['success']).to be false
    end
  end

  context "with invalid credentials rejects logout" do
    it "without token" do
      post url, params: { 'refresh_token': refresh_token }
      expect(response).to have_http_status(:unauthorized)
      expect(json_response['success']).to be false
    end

    it "if token expired" do
      auth_post(expired_token)
      expect(response).to have_http_status(:unauthorized)
      expect(json_response['success']).to be false
    end

    it "if refresh token is expired" do
      expired_refresh_token = generate_refresh_token_expired(user)
      auth_post(valid_token, { 'refresh_token': expired_refresh_token })
      expect(response).to have_http_status(:ok)
    end

    it "if token already in blacklist" do
      auth_post(valid_token)
      expect(response).to have_http_status(:ok)
      expect(JwtServices::BlacklistService.blacklisted?(valid_token)).to be true

      auth_post(valid_token)
      expect(response).to have_http_status(:unauthorized)
      expect(json_response['success']).to be false
    end

    it "if invalid token format" do
      auth_post("323jsaashhs")
      expect(response).to have_http_status(:unauthorized)
    end

    it "if inactive user" do
      auth_post(inactive_user_token)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "without refresh_token logout successfully" do
      it "if empty refresh_token" do
        auth_post(valid_token, { 'refresh_token': "" })
        expect(response).to have_http_status(:ok)
      end
      it "if invalid refresh_token" do
        auth_post(valid_token, { 'refresh_token': "3salsad" })
        expect(response).to have_http_status(:ok)
      end
  end
end