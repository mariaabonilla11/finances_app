class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, comment: "Tabla que almacena los usuarios del sistema" do |t|
      t.string :first_name, comment: "Nombre del usuario"
      t.string :last_name, comment: "Apellido del usuario"
      t.string :email, comment: "Correo electrónico del usuario"
      t.string :password_digest, comment: "Contraseña del usuario"
      t.integer :state, comment: "Estado del usuario"
      t.integer :created_by, comment: "Usuario que creó el registro"
      t.integer :updated_by, comment: "Usuario que actualizó el registro"

      t.timestamps
    end
  end
end
