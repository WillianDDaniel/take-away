class ChangeStatusTypeInBeverages < ActiveRecord::Migration[7.1]
  def change
    remove_column :beverages, :status
    add_column :beverages, :status, :integer, default: 1, null: false
  end
end
