class Beverage < ApplicationRecord
  belongs_to :restaurant

  validates :name, :alcoholic, presence: true

  has_one_attached :image

end
