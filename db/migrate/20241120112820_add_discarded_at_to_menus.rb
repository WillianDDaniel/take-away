class AddDiscardedAtToMenus < ActiveRecord::Migration[7.1]
  def change
    add_column :menus, :discarded_at, :datetime
    add_index :menus, :discarded_at
  end
end
