class Beverage < ApplicationRecord
  belongs_to :restaurant

  validates :name, :price, :alcoholic, presence: true

  has_one_attached :image

end
