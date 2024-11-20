class AddDiscardedAtToPortions < ActiveRecord::Migration[7.1]
  def change
    add_column :portions, :discarded_at, :datetime
    add_index :portions, :discarded_at
  end
end
