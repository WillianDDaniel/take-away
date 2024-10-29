class CreatePortions < ActiveRecord::Migration[7.1]
  def change
    create_table :portions do |t|
      t.string :description
      t.integer :price
      t.references :portionable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
