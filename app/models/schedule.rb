class Schedule < ApplicationRecord
  belongs_to :restaurant

  validates :open_time, :close_time, :week_day, presence: true

  validate :start_before_end

  def self.day_options
    I18n.t('date.day_names').map.with_index { |day, index| [day, index] }
  end

  def start_before_end
    if open_time.present? && close_time.present? && open_time >= close_time
      errors.add(:open_time, 'deve ser menor que o horário de fechamento')
    end
  end
end
