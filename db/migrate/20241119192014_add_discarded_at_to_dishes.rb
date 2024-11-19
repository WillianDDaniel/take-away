class AddDiscardedAtToDishes < ActiveRecord::Migration[7.1]
  def change
    add_column :dishes, :discarded_at, :datetime
    add_index :dishes, :discarded_at
  end
end
