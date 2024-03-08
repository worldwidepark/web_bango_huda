class AddIsShowedToBangoHuda < ActiveRecord::Migration[7.1]
  def change
    add_column :bango_hudas, :is_showed, :boolean, default: false
  end
end
