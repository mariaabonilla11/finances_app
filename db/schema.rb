# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_10_31_104510) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", comment: "Nombre cuenta"
    t.integer "balance", comment: "Saldo disponible"
    t.string "currency", comment: "Moneda"
    t.integer "state", comment: "Estado de la cuenta"
    t.integer "created_by", comment: "Usuario que creó el registro"
    t.integer "updated_by", comment: "Usuario que actualizó el registro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blacklisted_tokens", force: :cascade do |t|
    t.string "token", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_blacklisted_tokens_on_expires_at"
    t.index ["token"], name: "index_blacklisted_tokens_on_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", comment: "Nombre categoria"
    t.string "description", comment: "Descripción de la categoria"
    t.integer "state", comment: "Estado de la categoria"
    t.integer "created_by", comment: "Usuario que creó el registro"
    t.integer "updated_by", comment: "Usuario que actualizó el registro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_refresh_tokens_on_expires_at"
    t.index ["token"], name: "index_refresh_tokens_on_token", unique: true
    t.index ["user_id", "expires_at"], name: "index_refresh_tokens_on_user_id_and_expires_at"
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "value", comment: "Monto de la transaccion"
    t.datetime "date", comment: "Fecha de la transaccion"
    t.string "description", comment: "Descripcion de la transaccion"
    t.integer "state", default: 1, comment: "Estado de la transaccion"
    t.integer "created_by", comment: "Usuario que creó el registro"
    t.integer "updated_by", comment: "Usuario que actualizó el registro"
    t.bigint "type_transaction_id", null: false
    t.bigint "category_id", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["type_transaction_id"], name: "index_transactions_on_type_transaction_id"
  end

  create_table "type_transactions", force: :cascade do |t|
    t.string "name", comment: "Nombre tipo de transaccion"
    t.string "description", comment: "Descripción de la tipo de transaccion"
    t.integer "state", comment: "Estado de la tipo de transaccion"
    t.integer "created_by", comment: "Usuario que creó el registro"
    t.integer "updated_by", comment: "Usuario que actualizó el registro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", comment: "Tabla que almacena los usuarios del sistema", force: :cascade do |t|
    t.string "first_name", comment: "Nombre del usuario"
    t.string "last_name", comment: "Apellido del usuario"
    t.string "email", comment: "Correo electrónico del usuario"
    t.string "password_digest", comment: "Contraseña del usuario"
    t.integer "state", comment: "Estado del usuario"
    t.integer "created_by", comment: "Usuario que creó el registro"
    t.integer "updated_by", comment: "Usuario que actualizó el registro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "refresh_tokens", "users"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transactions", "type_transactions"
end
