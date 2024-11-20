class Menu < ApplicationRecord

  include Discard::Model

  belongs_to :restaurant

  has_many :menu_items, dependent: :destroy
  has_many :dishes, through: :menu_items, source: :menuable, source_type: 'Dish'
  has_many :beverages, through: :menu_items, source: :menuable, source_type: 'Beverage'
  has_many :orders

  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant_id, message: "Já existe um menu com esse nome neste restaurante." }

  accepts_nested_attributes_for :menu_items, allow_destroy: true
end
