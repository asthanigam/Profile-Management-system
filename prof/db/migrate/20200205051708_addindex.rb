class Addindex < ActiveRecord::Migration[5.1]
  def change
  	add_index :users, :username
  	add_index :users, :email_id
  	add_index :users, :created_at
  end
end
