require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'Valid?' do

    context 'when user information is missing' do
      it 'should not be valid without document_number' do
        user = User.new(
          name: 'John', last_name: 'Doe',
          email: 'johndoe@example.com', password: 'password12345'
        )

        expect(user).not_to be_valid
      end

      it 'should not be valid without name' do
        cpf = CPF.generate

        user = User.new(
          document_number: cpf, last_name: 'Doe',
          email: 'johndoe@example.com', password: 'password12345'
        )

        expect(user).not_to be_valid
      end

      it 'should not be valid without last_name' do
        cpf = CPF.generate

        user = User.new(
          document_number: cpf, name: 'John',
          email: 'johndoe@example.com', password: 'password12345'
        )

        expect(user).not_to be_valid
      end

      it 'should not be valid without email' do
        cpf = CPF.generate

        user = User.new(
          document_number: cpf, name: 'John', last_name: 'Doe',
          password: 'password12345'
        )

        expect(user).not_to be_valid
      end

      it 'should not be valid without password' do
        cpf = CPF.generate

        user = User.new(
          document_number: cpf, name: 'John', last_name: 'Doe',
          email: 'johndoe@example.com'
        )

        expect(user).not_to be_valid
      end
    end

    context 'when user information is valid' do
      it 'should be valid' do
        cpf = CPF.generate

        user = User.new(
          document_number: cpf, name: 'John', last_name: 'Doe',
          email: 'johndoe@example.com', password: 'password12345'
        )

        expect(user).to be_valid
      end
    end

    context 'document_number is not valid' do
      it 'should not be valid with invalid document_number' do
        user = User.new(
          document_number: '1245678900', name: 'John', last_name: 'Doe',
          email: 'johndoe@example.com', password: 'password12345'
        )

        expect(user).not_to be_valid
      end

      it 'should not be valid when document_number is not unique' do
        cpf = CPF.generate

        User.create!(
          document_number: cpf, name: 'John', last_name: 'Doe',
          email: 'johndoe@example.com', password: 'password12345'
        )

        user = User.new(
          document_number: cpf, name: 'John', last_name: 'Doe',
          email: 'johndoe@example.com', password: 'password12345'
        )

        expect(user).not_to be_valid
      end
    end

    context 'email is not valid' do
      it 'should not be valid with invalid email' do
        cpf = CPF.generate

        user = User.new(
          document_number: cpf, name: 'John', last_name: 'Doe',
          email: 'johndoe@example', password: 'password12345'
        )

        expect(user).not_to be_valid
      end

      it 'should not be valid when email is not unique' do
        cpf = CPF.generate
        other_cpf = CPF.generate

        User.create!(
          document_number: cpf, name: 'John', last_name: 'Doe',
          email: 'johndoe@example.com', password: 'password12345'
        )

        user = User.new(
          document_number: other_cpf, name: 'John', last_name: 'Doe',
          email: 'johndoe@example.com', password: 'password12345'
        )

        expect(user).not_to be_valid
      end
    end

    context 'password is not valid' do
      it 'should not be valid with invalid password' do
        cpf = CPF.generate

        user = User.new(
          document_number: cpf, name: 'John', last_name: 'Doe',
          email: 'johndoe@example.com', password: 'password'
        )

        expect(user).not_to be_valid
      end
    end

    context 'name and last_name is not valid' do
      it 'should not be valid with invalid name' do
        cpf = CPF.generate

        user = User.new(
          document_number: cpf, name: 'John@', last_name: 'Doe',
          email: 'johndoe@example.com', password: 'password12345'
        )

        expect(user).not_to be_valid
      end

      it 'should not be valid with invalid last_name' do
        cpf = CPF.generate

        user = User.new(
          document_number: cpf, name: 'John', last_name: 'Doe1234',
          email: 'johndoe@example.com', password: 'password12345'
        )

        expect(user).not_to be_valid
      end
    end
  end
end
