class CreateBeverages < ActiveRecord::Migration[7.1]
  def change
    create_table :beverages do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.boolean :alcoholic
      t.integer :calories
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
