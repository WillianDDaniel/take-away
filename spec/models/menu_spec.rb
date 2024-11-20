require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '#valid?' do
    it 'is invalid without a name' do
      menu = Menu.new(name: nil)
      expect(menu).not_to be_valid
      expect(menu.errors.include?(:name)).to be true
    end

    it 'is invalid without a restaurant' do
      menu = Menu.new(restaurant: nil)
      expect(menu).not_to be_valid
      expect(menu.errors.include?(:restaurant)).to be true
    end

    it 'is invalid with a duplicated name' do

      User.create!(email: 'johndoes@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoes@example.com', phone: '11999999999', address: 'Rua Teste', user: User.last
      )

      Menu.create!(name: 'Teste', restaurant: Restaurant.last)
      menu = Menu.new(name: 'Teste', restaurant: Restaurant.last)
      expect(menu).not_to be_valid
      expect(menu.errors.include?(:name)).to be true
    end
  end

  describe 'discard' do
    it 'should be set to discarded' do
      user = User.create!(email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      menu = Menu.create!(name: 'Teste', restaurant: restaurant)

      menu.discard
      expect(menu.discarded_at).not_to be_nil
    end
  end
end
