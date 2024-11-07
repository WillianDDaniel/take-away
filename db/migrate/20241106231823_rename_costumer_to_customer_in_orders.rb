class RenameCostumerToCustomerInOrders < ActiveRecord::Migration[7.1]
  def change
    rename_column :orders, :costumer_name, :customer_name
    rename_column :orders, :costumer_phone, :customer_phone
    rename_column :orders, :costumer_email, :customer_email
    rename_column :orders, :costumer_doc, :customer_doc
  end
end
