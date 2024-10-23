class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise(
    :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
  )

  has_one :restaurant

  validates :name, :last_name, :document_number, presence: true
  validates :document_number, uniqueness: true

  validate :cpf_must_be_valid
  validate :only_letters

  private

  def cpf_must_be_valid
    errors.add(:document_number, 'inválido') unless CPF.valid?(document_number)
  end

  def only_letters
    if name.present? && name !~ /\A[a-zA-Z]+\z/
      errors.add(:name, 'deve conter apenas letras')
    end

    if last_name.present? && last_name !~ /\A[a-zA-Z]+\z/
      errors.add(:last_name, 'deve conter apenas letras')
    end
  end
end