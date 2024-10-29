class AddStatusToDishes < ActiveRecord::Migration[7.1]
  def change
    add_column :dishes, :status, :string, default: 'active', null: false
  end
end
