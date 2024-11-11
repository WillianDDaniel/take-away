class Employee < ApplicationRecord
  belongs_to :restaurant

  validates :email, presence: true
  validates :email, uniqueness: true
  validate :email_must_be_unique
  validate :email_must_be_valid

  validates :doc_number, presence: true
  validates :doc_number, uniqueness: true
  validate :doc_number_must_be_unique
  validate :cpf_must_be_valid

  after_create :set_default_registered

  private

  def email_must_be_valid
    email_regexp = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    unless email_regexp.match?(email)
      errors.add(:email, 'inválido') unless email.blank?
    end
  end

  def email_must_be_unique
    errors.add(:email, 'já está em uso') if User.exists?(email: email)
  end

  def doc_number_must_be_unique
    errors.add(:doc_number, 'já está em uso') if User.exists?(document_number: doc_number)
  end

  def cpf_must_be_valid
    errors.add(:doc_number, 'inválido') unless CPF.valid?(doc_number)
  end

  def set_default_registered
    self.registered = false
  end
end
