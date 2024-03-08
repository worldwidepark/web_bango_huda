class CreateBangoHudas < ActiveRecord::Migration[7.1]
  def change
    create_table :bango_hudas do |t|
      t.integer :bango, null: false
      t.boolean :is_no_show, default: false
      t.boolean :is_done, default: false
      t.boolean :is_canceled, default: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
