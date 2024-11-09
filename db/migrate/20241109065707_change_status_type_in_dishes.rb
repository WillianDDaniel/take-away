class ChangeStatusTypeInDishes < ActiveRecord::Migration[7.1]
  def change
    remove_column :dishes, :status
    add_column :dishes, :status, :integer, default: 1, null: false
  end
end
