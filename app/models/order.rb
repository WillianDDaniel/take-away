class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :menu

  accepts_nested_attributes_for :order_items, allow_destroy: true

  validates :customer_name, presence: true

  validate :phone_or_email_present
  validate :must_have_at_least_one_item

  validate :phone_must_be_valid
  validate :doc_must_be_valid
  validate :email_must_be_valid

  enum status: {
    pending: 0,
    preparing: 1,
    cancelled: 2,
    ready: 3,
    delivered: 4
  }

  before_create :generate_code
  before_create :set_default_status

  def status_i18n
    I18n.t("activerecord.attributes.order.enums.status.#{status}")
  end

  def total_price
    order_items.reduce(0) { |acc, item| acc + item.portion.price * item.quantity }
  end

  private

  def phone_or_email_present
    if customer_phone.blank? && customer_email.blank?
      errors.add(:base, "Pelo menos um contato deve ser preenchido (telefone ou email).")
    end
  end

  def doc_must_be_valid
    unless CPF.valid?(customer_doc)
      errors.add(:customer_doc, 'inválido') unless customer_doc.blank?
    end
  end

  def email_must_be_valid
    email_regexp = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    unless email_regexp.match?(customer_email)
      errors.add(:customer_email, 'inválido') unless customer_email.blank?
    end
  end

  def phone_must_be_valid
    return unless customer_phone

    if customer_phone.length < 10 || customer_phone.length > 11
      errors.add(:customer_phone, 'inválido') unless customer_phone.blank?
    end
  end

  def must_have_at_least_one_item
    if order_items.empty?
      errors.add(:base, "Nenhum item adicionado ao pedido")
    end
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def set_default_status
    self.status ||= :pending
  end
end
