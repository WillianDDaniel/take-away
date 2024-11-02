class Tag < ApplicationRecord
  has_many :tag_dishes
  has_many :dishes, through: :tag_dishes
  belongs_to :restaurant

  validates :name, presence: true
end
