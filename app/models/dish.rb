class Dish < ApplicationRecord
  belongs_to :restaurant

  has_many :portions, as: :portionable
  has_many :tag_dishes, dependent: :destroy
  has_many :tags, through: :tag_dishes
  has_many :menu_items, as: :menuable, dependent: :destroy
  has_many :menus, through: :menu_items

  has_one_attached :image

  validates :name, presence: true
  validate :calories_must_be_positive

  enum status: {
    active: 1,
    paused: 5
  }

  before_validation :set_tags_restaurant

  accepts_nested_attributes_for :tags, reject_if: :all_blank, allow_destroy: true

  private

  def calories_must_be_positive
    if calories.present?
      errors.add(:calories, 'deve ser positivo') if calories < 0
    end
  end


  def set_tags_restaurant
    tags.each do |tag|
      tag.restaurant_id = self.restaurant_id if tag.new_record?
    end
  end
end
