class CreateRefreshTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :refresh_tokens do |t|
        t.references :user, null: false, foreign_key: true, index: true
        t.string :token, null: false, index: { unique: true }
        t.datetime :expires_at, null: false
        t.timestamps  
    end
    add_index :refresh_tokens, :expires_at
    add_index :refresh_tokens, [:user_id, :expires_at]
  end
end
