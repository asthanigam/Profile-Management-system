class Type < ActiveRecord::Migration[5.1]
  def change
  	execute <<-SQL
  		CREATE TYPE user_type AS ENUM ('buyer','seller','broker');
  	 SQL
  	add_column :users, :user_category, :user_type, :default => 'buyer'
  end
end
