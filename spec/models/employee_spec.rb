require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe '#valid?' do
    it 'is invalid with email thas already been taken' do
      User.create!(
        email: 'johndoe@example.com', document_number: CPF.generate, name: 'John',
        last_name: 'Doe', password: 'password12345'
      )
      employee = Employee.new(email: 'johndoe@example.com')
      expect(employee.valid?).to be false
      expect(employee.errors.include?(:email)).to be true
    end

    it 'is invalid without an email' do
      employee = Employee.new
      expect(employee.valid?).to be false
      expect(employee.errors.include?(:email)).to be true
    end

    it 'is invalid with document number thas already been taken' do
      doc_number = CPF.generate
      User.create!(
        email: 'johndoe@example.com', document_number: doc_number, name: 'John',
        last_name: 'Doe', password: 'password12345'
      )

      employee = Employee.new(doc_number: doc_number)
      expect(employee.valid?).to be false
      expect(employee.errors.include?(:doc_number)).to be true
    end

    it 'is invalid without a document number' do
      employee = Employee.new
      expect(employee.valid?).to be false
      expect(employee.errors.include?(:doc_number)).to be true
    end

    it 'is invalid without a restaurant' do
      employee = Employee.new(restaurant: nil)
      expect(employee.valid?).to be false
      expect(employee.errors.include?(:restaurant)).to be true
    end

    it 'is valid with valid attributes' do
      user = User.create!(
        email: 'user@example.com', document_number: CPF.generate, name: 'John',
        last_name: 'Doe', password: 'password12345'
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', email: 'restaurant@example.com',
        phone: '11999999999', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      employee = Employee.new(email: 'employee@example.com', doc_number: CPF.generate, restaurant: restaurant)
      expect(employee.valid?).to be true
    end
  end

  describe 'employee register status' do
    it 'is inactive by default' do
      user = User.create!(
        email: 'user@example.com', document_number: CPF.generate, name: 'John',
        last_name: 'Doe', password: 'password12345'
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', email: 'restaurant@example.com',
        phone: '11999999999', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      employee = Employee.create!(email: 'employee@example.com', doc_number: CPF.generate, restaurant: restaurant)
      expect(employee.registered).to be false
    end

    it 'is active after registration' do
      user = User.create!(
        email: 'user@example.com', document_number: CPF.generate, name: 'John',
        last_name: 'Doe', password: 'password12345'
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', email: 'restaurant@example.com',
        phone: '11999999999', address: 'Rua Teste',
        doc_number: CNPJ.generate, user: user
      )

      staff_document = CPF.generate
      employee = Employee.create!(
        email: 'employee@example.com', doc_number: staff_document, restaurant: restaurant
      )

      staff_user = User.new(
        email: 'employee@example.com', document_number: staff_document, name: 'John',
        last_name: 'Doe', password: 'password12345'
      )
      staff_user.save!

      expect(staff_user.staff?).to be true
      expect(employee.reload.registered).to be true
    end
  end
end
