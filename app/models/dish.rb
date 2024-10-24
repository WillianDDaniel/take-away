class Dish < ApplicationRecord
  belongs_to :restaurant

  validates :name, :price, presence: true
end
