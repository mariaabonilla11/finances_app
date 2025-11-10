class TypeTransactionsController < ApplicationController
  def create
    type_transaction = TypeTransaction.new(params)
    if type_transaction.save
      render json: { message: "Type Transaction created!" }, status: :created
    else
      render json: { errors: type_transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
