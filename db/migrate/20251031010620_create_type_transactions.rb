class CreateTypeTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :type_transactions do |t|
      t.string :name, comment: "Nombre tipo de transaccion"
      t.string :description, comment: "Descripción de la tipo de transaccion"
      t.integer :state, comment: "Estado de la tipo de transaccion"
      t.integer :created_by, comment: "Usuario que creó el registro"
      t.integer :updated_by, comment: "Usuario que actualizó el registro"

      t.timestamps
    end
  end
end
