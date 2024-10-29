class Dish < ApplicationRecord
  belongs_to :restaurant

  has_many :portions, as: :portionable

  validates :name, presence: true

  validate :calories_must_be_positive

  has_one_attached :image

  enum status: { active: 'active', paused: 'paused' }

  def calories_must_be_positive
    if calories.present?
      errors.add(:calories, 'deve ser positivo') if calories < 0
    end
  end
end
