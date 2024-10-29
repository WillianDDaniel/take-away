class Portion < ApplicationRecord
  belongs_to :portionable, polymorphic: true

  validates :description, :price, presence: true
end
