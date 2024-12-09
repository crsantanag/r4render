class AddDetailsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string
    add_column :users, :telephone, :integer
    add_column :users, :picture, :string
    add_column :users, :role, :integer, default: 0
  end
end
