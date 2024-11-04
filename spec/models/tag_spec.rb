require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe '#valid?' do
    it 'is invalid without a name' do
      tag = Tag.new(name: nil)
      expect(tag).not_to be_valid
      expect(tag.errors.include?(:name)).to be true
    end

    it 'is invalid without a restaurant' do
      tag = Tag.new(restaurant: nil)
      expect(tag).not_to be_valid
      expect(tag.errors.include?(:restaurant)).to be true
    end
  end

  describe 'associations' do
    it 'has many dishes' do
      user = User.new(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user)

      first_dish = Dish.create!(name: 'Prato Teste', description: 'Descricão do prato teste',
        calories: 10, restaurant: Restaurant.first)

      second_dish = Dish.create!(name: 'Prato Teste 2', description: 'Descricão do prato teste 2',
        calories: 10, restaurant: Restaurant.first)

      tag = Tag.create!(name: 'Teste', restaurant: Restaurant.first)

      first_dish.tags << tag
      second_dish.tags << tag

      expect(tag.dishes).to include(first_dish)
      expect(tag.dishes).to include(second_dish)

      expect(tag.dishes.count).to eq(2)
      expect(tag).to respond_to(:tag_dishes)
    end

    it 'belongs to a restaurant' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste Corp', doc_number: CNPJ.generate,
        email: 'restaurant@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      tag = Tag.create!(name: 'Promoção', restaurant: restaurant)

      expect(tag.restaurant).to eq(restaurant)
      expect(tag.restaurant.brand_name).to eq('Teste')
      expect(tag).to respond_to(:restaurant)
    end

    it 'has many tag_dishes' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste Corp', doc_number: CNPJ.generate,
        email: 'restaurant@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      tag = Tag.create!(name: 'Favorito', restaurant: restaurant)

      first_dish = Dish.create!(
        name: 'Prato Especial 1', description: 'Descrição do primeiro prato especial',
        calories: 250, restaurant: restaurant
      )

      second_dish = Dish.create!(
        name: 'Prato Especial 2', description: 'Descrição do segundo prato especial',
        calories: 300, restaurant: restaurant
      )

      first_dish.tags << tag
      second_dish.tags << tag

      expect(tag.tag_dishes.count).to eq(2)
      expect(tag.tag_dishes.map(&:dish)).to include(first_dish, second_dish)
      expect(tag).to respond_to(:tag_dishes)
    end
  end
end
