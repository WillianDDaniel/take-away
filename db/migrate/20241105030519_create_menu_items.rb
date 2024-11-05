class CreateMenuItems < ActiveRecord::Migration[7.1]
  def change
    create_table :menu_items do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :menuable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
