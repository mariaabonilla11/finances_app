class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update ]
  include ParameterValidator
  include Authenticable

  # GET /transactions or /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  def create
    result_validate = validate_required_params([:value, :date, :description, :type_transaction_id, :category_id, :account_id])
    if !result_validate[:valid]
      return render json: { success: false, message: 'Faltan parámetros requeridos', errors: result_validate[:result] }, status: :bad_request
    end

    unless validate_date_format(params[:date])
      return render json: { success: false, message: 'Formato de fecha inválido', errors: [{ field: 'date', message: "El campo 'date' debe tener formato ISO8601 (ejemplo: '2035-09-09T14:34:15Z')" }] }, status: :unprocessable_entity
    end

    transaction_params = params.permit(:value, :date, :description, :type_transaction_id, :category_id, :account_id)
    result = Transactions::TransactionService.create(transaction_params, current_user)

    if result[:success]
      render json: { success: true, message: result[:message], data: result[:data] }, status: :created
    else
      render json: { success: false, message: result[:message], errors: result[:errors] }, status: :unprocessable_entity
    end

  end

  def update
    transaction_params = params.permit(:value, :date, :description, :type_transaction_id, :category_id, :account_id)
    if params[:date] && !validate_date_format(params[:date])
      return render json: { success: false, message: 'Formato de fecha inválido', errors: [{ field: 'date', message: "El campo 'date' debe tener formato ISO8601 (ejemplo: '2035-09-09T14:34:15Z')" }] }, status: :unprocessable_entity
    end
    
    result = Transactions::TransactionService.update(params[:id], transaction_params, current_user)

    if result[:success]
      render json: { success: true, data: result[:data] }, status: :ok
    else
      render json: { success: false, message: result[:message], errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find_by(id: params[:id])
      unless @transaction
        render json: { success: false, message: "No se encontró transacción con id #{params[:id]}" }, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:value, :date, :state, :created_by, :updated_by)
    end
end
