class RemovePriceFromBeveragesAndDishes < ActiveRecord::Migration[7.1]
  def change
    remove_column :beverages, :price, :integer
    remove_column :dishes, :price, :integer
  end
end
