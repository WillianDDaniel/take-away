class AddStatusToBeverages < ActiveRecord::Migration[7.1]
  def change
    add_column :beverages, :status, :string, default: 'active', null: false
  end
end
