class AddUuidToBangohudas < ActiveRecord::Migration[7.1]
  def change
    add_column :bango_hudas, :uuid, :string
    add_index :bango_hudas, :uuid, unique: true
  end
end
