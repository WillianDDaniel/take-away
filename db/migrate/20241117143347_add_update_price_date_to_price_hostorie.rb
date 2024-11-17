class AddUpdatePriceDateToPriceHostorie < ActiveRecord::Migration[7.1]
  def change
    add_column :price_histories, :updated_price_date, :date
  end
end
