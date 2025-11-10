class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name, comment: "Nombre categoria"
      t.string :description, comment: "Descripción de la categoria"
      t.integer :state, comment: "Estado de la categoria"
      t.integer :created_by, comment: "Usuario que creó el registro"
      t.integer :updated_by, comment: "Usuario que actualizó el registro"
      t.timestamps
    end
  end
end
