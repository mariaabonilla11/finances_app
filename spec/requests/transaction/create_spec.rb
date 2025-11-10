require 'rails_helper'
require './spec/support/request_helpers'


RSpec.describe "POST /transactions", type: :request do
  let(:url) { '/transactions' }
  let(:user) { create(:user, password: 'password123', state: :active) }
  let(:auth_token) { generate_token(user) }
  let(:type_transaction) { create(:type_transaction) }
  let(:category) { create(:category) }
  let(:account) { create(:account) }
  let(:params) do
    {
      value: 10000,
      date: "2035-09-09T14:34:15Z",
      description: "Compras recientes",
      type_transaction_id: type_transaction.id,
      category_id: category.id,
      account_id: account.id
    }
  end

  context "with valid parameters" do
    it "creates a transaction successfully" do
      expect {
        post url, headers: { Authorization: "Bearer #{auth_token}" }, params: params
      }.to change(Transaction, :count).by(1)

      expect(response).to have_http_status(:created)

      transaction = Transaction.order(:created_at).last
      expect(transaction).to have_attributes(
        value: params[:value],
        account_id: params[:account_id],
        category_id: params[:category_id],
        type_transaction_id: params[:type_transaction_id],
        description: params[:description]
      )

      expect(json_response).to include(
        'success' => true,
        'message' => a_string_including('Transacción creada exitosamente'),
        'data' => a_kind_of(Hash)
      )

      expect(json_response['data']).to include(
        'id' => transaction.id,
        'value' => transaction.value,
        'description' => transaction.description,
        'account_id' => transaction.account_id,
        'category_id' => transaction.category_id,
        'type_transaction_id' => transaction.type_transaction_id
      )
    end
  end

  context "when other required parameters are missing" do
    [:value, :date, :type_transaction_id, :category_id, :account_id].each do |param|
      it "returns an error when #{param} is missing" do
        invalid_params = params.except(param)

        post url, headers: { Authorization: "Bearer #{auth_token}" }, params: invalid_params
        expect(response).to have_http_status(:bad_request)
        expect(json_response).to include(
          'success' => false,
          'message' => a_string_including("Faltan parámetros requeridos"),
          'errors' => a_kind_of(Array)
        )

        expect(json_response['errors'].first).to include(
          "message" => a_string_including("El campo '#{param}' es requerido")
        )
      end
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
end