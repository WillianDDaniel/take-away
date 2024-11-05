class Tag < ApplicationRecord
  belongs_to :restaurant

  has_many :tag_dishes
  has_many :dishes, through: :tag_dishes

  validates :name, presence: true
end
