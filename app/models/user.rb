class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :last_name, :document_number, presence: true
  validates :document_number, uniqueness: true
  validate :cpf_must_be_valid

  private

  def cpf_must_be_valid
    unless CPF.valid?(document_number)
      errors.add(:document_number, 'inválido')
    end
  end

end