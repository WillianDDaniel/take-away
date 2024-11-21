class AddCancelReasonToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :cancel_reason, :string
  end
end
