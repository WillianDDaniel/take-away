class Restaurant < ApplicationRecord
  belongs_to :user

  has_many :schedules
  has_many :dishes
  has_many :employees
  has_many :beverages
  has_many :menus
  has_many :orders, through: :menus

  validates(
    :brand_name, :corporate_name, :doc_number,
    :email, :address, :phone, presence: true
  )
  validates(:doc_number, uniqueness: true)

  validate :doc_must_be_valid
  validate :email_must_be_valid
  validate :phone_must_be_valid

  before_validation :generate_code

  after_create :set_user_as_owner

  private

  def set_user_as_owner
    user.update(role: 'owner')
  end

  def doc_must_be_valid
    unless CNPJ.valid?(doc_number)
      errors.add(:doc_number, 'inválido') unless doc_number.blank?
    end
  end

  def email_must_be_valid
    email_regexp = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    unless email_regexp.match?(email)
      errors.add(:email, 'inválido') unless email.blank?
    end
  end

  def phone_must_be_valid
    if phone.length < 10 || phone.length > 11
      errors.add(:phone, 'inválido') unless phone.blank?
    end
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(6).upcase
  end

end
