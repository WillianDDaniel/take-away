require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'valid?' do

    let(:user) do
      User.create!(
        email: 'johndoe@example.com',
        name: 'John',
        last_name: 'Doe',
        password: 'password12345',
        document_number: CPF.generate
      )
    end

    context 'sucessfully' do
      it 'should be valid with all valid attributes' do
        restaurant = Restaurant.new(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
          email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
        )

        expect(restaurant).to be_valid
      end

      it 'should have a random code' do
        restaurant = Restaurant.create!(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
          email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
        )

        expect(restaurant.code).not_to be_nil
      end
    end

    context 'must be invalid without attributes' do
      it 'if brand_name is blank' do
        restaurant = Restaurant.new(brand_name: '', corporate_name: 'Teste', doc_number: CNPJ.generate,
          email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
        )

        restaurant.valid?
        expect(restaurant.errors.include?(:brand_name)).to be true
        expect(restaurant).not_to be_valid
      end

      it 'if corporate_name is blank' do
        restaurant = Restaurant.new(brand_name: 'Teste', corporate_name: '', doc_number: CNPJ.generate,
          email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
        )

        restaurant.valid?
        expect(restaurant.errors.include?(:corporate_name)).to be true
        expect(restaurant).not_to be_valid
      end

      it 'if doc_number is blank' do
        restaurant = Restaurant.new(brand_name: 'Teste', corporate_name: 'Teste', doc_number: '',
          email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
        )

        restaurant.valid?
        expect(restaurant.errors.include?(:doc_number)).to be true
        expect(restaurant).not_to be_valid
      end

      it 'if email is blank' do
        restaurant = Restaurant.new(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
          email: '', phone: '11999999999', address: 'Rua Teste', user: user
        )

        restaurant.valid?
        expect(restaurant.errors.include?(:email)).to be true
        expect(restaurant).not_to be_valid
      end

      it 'if phone is blank' do
        restaurant = Restaurant.new(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
          email: 'johndoe@example.com', phone: '', address: 'Rua Teste', user: user
        )

        restaurant.valid?
        expect(restaurant.errors.include?(:phone)).to be true
        expect(restaurant).not_to be_valid
      end

      it 'if address is blank' do
        restaurant = Restaurant.new(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
          email: 'johndoe@example.com', phone: '11999999999', address: '', user: user
        )

        restaurant.valid?
        expect(restaurant.errors.include?(:address)).to be true
        expect(restaurant).not_to be_valid
      end
    end
  end
end
