class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.integer :value, comment: "Monto de la transaccion"
      t.datetime :date, comment: "Fecha de la transaccion"
      t.string :description, comment: "Descripcion de la transaccion"
      t.integer :state,  default: 1, comment: "Estado de la transaccion"
      t.integer :created_by, comment: "Usuario que creó el registro"
      t.integer :updated_by, comment: "Usuario que actualizó el registro"
      t.references :type_transaction, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
