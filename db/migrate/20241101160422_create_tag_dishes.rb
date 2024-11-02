class CreateTagDishes < ActiveRecord::Migration[7.1]
  def change
    create_table :tag_dishes do |t|
      t.references :dish, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
