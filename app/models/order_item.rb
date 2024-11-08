class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :portion

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
