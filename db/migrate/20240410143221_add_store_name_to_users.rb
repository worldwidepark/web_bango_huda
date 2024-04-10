class AddStoreNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :store_name, :string
  end
end
