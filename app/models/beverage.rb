class Beverage < ApplicationRecord
  belongs_to :restaurant

  validates :name, presence: true
  validates :alcoholic, inclusion: { in: [true, false] }

  validate :calories_must_be_positive

  has_one_attached :image

  enum status: { active: 'active', paused: 'paused' }

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
