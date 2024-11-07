class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :code
      t.string :costumer_name
      t.string :costumer_phone
      t.string :costumer_email
      t.string :costumer_doc

      t.timestamps
    end
  end
end
