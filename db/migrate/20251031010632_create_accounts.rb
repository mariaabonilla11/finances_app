class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts do |t|
        t.string :name, comment: "Nombre cuenta"
        t.integer :balance, comment: "Saldo disponible"
        t.string :currency, comment: "Moneda"
        t.integer :state, comment: "Estado de la cuenta"
        t.integer :created_by, comment: "Usuario que creó el registro"
        t.integer :updated_by, comment: "Usuario que actualizó el registro"
      t.timestamps
    end
  end
end
