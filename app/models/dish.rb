class Dish < ApplicationRecord
  belongs_to :restaurant

  validates :name, :price, presence: true

  has_one_attached :image

end
