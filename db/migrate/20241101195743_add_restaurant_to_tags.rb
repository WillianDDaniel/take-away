class AddRestaurantToTags < ActiveRecord::Migration[7.1]
  def change
    add_reference :tags, :restaurant, foreign_key: true
  end
end
