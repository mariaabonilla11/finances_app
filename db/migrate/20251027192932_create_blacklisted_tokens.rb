class CreateBlacklistedTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :blacklisted_tokens do |t|
      t.string :token, null: false
      t.datetime :expires_at, null: false 
      t.timestamps
    end
      add_index :blacklisted_tokens, :token, unique: true
      add_index :blacklisted_tokens, :expires_at
  end
end
