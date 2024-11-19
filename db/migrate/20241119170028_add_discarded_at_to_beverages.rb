class AddDiscardedAtToBeverages < ActiveRecord::Migration[7.1]
  def change
    add_column :beverages, :discarded_at, :datetime
    add_index :beverages, :discarded_at
  end
end
