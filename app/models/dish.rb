class Dish < ApplicationRecord
  belongs_to :restaurant

  validates :name, presence: true

  has_one_attached :image

end
