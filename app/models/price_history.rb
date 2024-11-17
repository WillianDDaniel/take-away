class PriceHistory < ApplicationRecord
  belongs_to :portion

  validates :price, presence: true

  before_create :set_updated_price_date

  private

  def set_updated_price_date
    self.updated_price_date = Date.today
  end
end
