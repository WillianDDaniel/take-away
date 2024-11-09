class Beverage < ApplicationRecord
  belongs_to :restaurant

  has_many :portions, as: :portionable
  has_many :menu_items, as: :menuable, dependent: :destroy
  has_many :menus, through: :menu_items

  validates :name, presence: true
  validates :alcoholic, inclusion: { in: [true, false] }

  validate :calories_must_be_positive

  has_one_attached :image

  enum status: {
    active: 1,
    paused: 5
  }

  before_validation :set_default_alcoholic

  def set_default_alcoholic
    self.alcoholic = false if alcoholic.nil?
  end

  def calories_must_be_positive
    if calories.present?
      errors.add(:calories, 'deve ser positivo') if calories < 0
    end
  end
end
