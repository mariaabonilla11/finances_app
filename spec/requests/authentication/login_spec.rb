require 'rails_helper'
require './spec/support/request_helpers'


RSpec.describe "POST /auth/login", type: :request do
  let(:url) { '/auth/login' }
  let(:password) { 'TestPassword123!' }
  let!(:user) { create(:user, password: password, state: :active) }


  context "with valid credentials" do
    it "authenticates successfully" do
      post url, params: { email: user.email, password: password }, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_response['success']).to be true
      expect(json_response['token']).to be_present
      expect(json_response['exp']).to be_present
      expect(json_response['user']).to be_present
    end
  end

  context "with invalid credentials" do
    it "rejects wrong password" do
      post url, params: { email: user.email, password: 'WrongPassword' }, as: :json
      
      expect(response).to have_http_status(:unauthorized)
      expect(json_response['success']).to be false
    end

    it "rejects non-existent email" do
      post url, params: { email: 'nonexistent@example.com', password: password }, as: :json
      
      expect(response).to have_http_status(:unauthorized)
      expect(json_response['success']).to be false
    end
  end

  context "with inactive user" do
    let!(:inactive_user) { create(:user, state: :inactive, password: password) }

    it "rejects login" do
      post url, params: { email: inactive_user.email, password: password }, as: :json
      
      expect(response).to have_http_status(:unauthorized)
      expect(json_response['success']).to be false
    end
  end

  context "with missing parameters" do
    it "requires email" do
      post url, params: { password: password }, as: :json
      
      expect(response).to have_http_status(:bad_request)
      expect(json_response['success']).to be false
      expect(json_response['errors']).not_to be_empty
      expect(json_response['errors']).to be_an(Array)
    end

    it "requires password" do
      post url, params: { email: user.email }, as: :json
      
      expect(response).to have_http_status(:bad_request)
      expect(json_response['success']).to be false
      expect(json_response['errors']).not_to be_empty
      expect(json_response['errors']).to be_an(Array)
    end
  end
end