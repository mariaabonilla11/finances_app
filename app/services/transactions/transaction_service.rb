module Transactions
  class TransactionService

    def self.create(params, current_user)
      begin

        transaction = ::Transaction.new(
          value: params[:value],
          date: Time.zone.parse(params[:date]),
          description: params[:description],
          type_transaction_id: params[:type_transaction_id],
          category_id: params[:category_id],
          account_id: params[:account_id],
          created_by: current_user.id
        )

        if transaction.save
          { success: true, message: "Transacción creada exitosamente", data: transaction }
        else
          { success: false, message: 'Error al crear la transacción', errors: transaction.errors.full_messages }
        end
      rescue => e
        { success: false, message: 'Error en TransactionService ', errors: e.message }
      end
    end

    def self.update(id, params, current_user)
      begin
        transaction = ::Transaction.find_by(id: id)

        # Normaliza fecha si viene presente
        if params[:date].present?
          params[:date] = Time.zone.parse(params[:date]) rescue nil
        end

        if transaction.update(params.merge(updated_by: current_user.id))
          { success: true, data: transaction }
        else
          { success: false,  message: 'Error al actualizar la transacción', errors: transaction.errors.full_messages }
        end
      rescue => e
        { success: false, message: 'Error en TransactionService ', errors: e.message }
      end
    end
  end
end