class AddIsResetedToBangoHuda < ActiveRecord::Migration[7.1]
  def change
    add_column :bango_hudas, :is_reseted, :boolean, default: false
  end
end
