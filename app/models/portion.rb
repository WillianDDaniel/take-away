class Portion < ApplicationRecord

  include Discard::Model

  belongs_to :portionable, polymorphic: true
  has_many :price_histories, dependent: :destroy

  validates :description, :price, presence: true

  before_update :save_price_changes

  private

  def save_price_changes
    if price_changed?
      price_histories.create(price: price_was)
    end
  end
end
