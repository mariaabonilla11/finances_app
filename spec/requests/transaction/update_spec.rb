require 'rails_helper'
require './spec/support/request_helpers'


RSpec.describe "PATCH /transactions", type: :request do
  let(:url) { '/transactions' }
  let(:user) { create(:user, password: 'password123', state: :active) }
  let(:type_transaction) { create(:type_transaction) }
  let(:category) { create(:category) }
  let(:account) { create(:account) }
  let(:auth_token) { generate_token(user) }
  let(:params) do
    {
      value: 150000,
      date: "2035-11-10T14:34:15Z",
      description: "Compras recientes actualizadas",
      type_transaction_id: type_transaction.id,
      category_id: category.id,
      account_id: account.id
    }
  end

  context "with valid parameters" do
    it "updates a transaction successfully" do
      transaction = create(:transaction, created_by: user.id, account: account, category: category, type_transaction: type_transaction)
      patch "#{url}/#{transaction.id}", headers: { Authorization: "Bearer #{auth_token}" }, params: params
      
      expect(response).to have_http_status(:ok)
      expect(json_response).to include(
        'success' => true,
        'data' => a_kind_of(Hash)
      )
      expect(json_response['data']).to include(
        'value' => params[:value],
        'description' => params[:description],
        'account_id' => params[:account_id],
        'category_id' => params[:category_id],
        'type_transaction_id' => params[:type_transaction_id]
      )
    end
  end

  context "when param date format is invalid" do
    it "returns a bad request error" do
      invalid_params = params.merge(date: "invalid-date-format")

      post url, headers: { Authorization: "Bearer #{auth_token}" }, params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response).to include(
        'success' => false,
        'message' => a_string_including('Formato de fecha inválido'),
        'errors' => a_kind_of(Array)
      )
    end
  end

  context "with invalid auth token" do
    it "returns an unauthorized error" do
      post url, headers: { Authorization: "Bearer invalid_token" }, params: params
      expect(response).to have_http_status(:unauthorized)
      expect(json_response).to include(
        'success' => false,
        'message' => a_string_including('Token inválido o expirado')
      )
    end

    it "returns an unauthorized error without token" do
      post url, params: params
      expect(response).to have_http_status(:unauthorized)
      expect(json_response).to include(
        'success' => false,
        'message' => a_string_including('Token no proporcionado')
      )
    end
  end
end