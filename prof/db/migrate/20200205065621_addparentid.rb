class Addparentid < ActiveRecord::Migration[5.1]
  def change
  	execute <<-SQL
  		CREATE TYPE user_status AS ENUM ('active','inactive');
  	 SQL
  	add_column :users, :user_status, :user_status, :default => 'active'
  	add_column :users, :parent_id
  end
end
