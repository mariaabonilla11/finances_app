require 'rails_helper'
require './spec/support/request_helpers'

RSpec.describe "POST /auth/register", type: :request do
  let(:url) { '/auth/register' }
  let(:password) { 'TestPassword123!' }
  required_fields = [:first_name, :last_name, :email, :password]
  let(:valid_params) do
    {
      first_name: "John",
      last_name: "Doe",
      email: build(:user).email,
      password: password,
      state: :active
    }
  end

  context "with valid parameters" do
    it "creates a new user and returns token" do
      post url, params: valid_params, as: :json

      expect(response).to have_http_status(:created)
      expect(json_response['success']).to be true
    end
  end

  # Tests missing fields
  required_fields.each do |field|
    context "without #{field}" do
      it "returns bad request with validation errors" do
        post url, params: valid_params.except(field), as: :json

        expect(response).to have_http_status(:bad_request)
        expect(json_response['success']).to be false
        expect(json_response['errors']).to be_an(Array).and(be_present)
        expect(json_response['errors']).not_to be_empty
      end
    end
  end

  context "with existing email" do
    let!(:existing_user) { create(:user, email: valid_params[:email], password: valid_params[:password]) }

    it "rejects duplicate email registration" do
      post url, params: valid_params, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['success']).to be false
      expect(json_response['errors']).to be_an(Array).and(be_present)
      expect(json_response['errors']).not_to be_empty
    end
  end
end