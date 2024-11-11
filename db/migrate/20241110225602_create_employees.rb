class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :email
      t.string :doc_number
      t.boolean :resgistered
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
