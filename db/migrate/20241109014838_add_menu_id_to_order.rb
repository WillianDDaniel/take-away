class AddMenuIdToOrder < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :menu, null: false, foreign_key: true
  end
end
