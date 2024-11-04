require 'rails_helper'

RSpec.describe TagDish, type: :model do

  describe '#valid?' do
    it 'is invalid without a tag' do
      tag_dish = TagDish.new(tag: nil)
      expect(tag_dish).not_to be_valid
      expect(tag_dish.errors.include?(:tag)).to be true
    end

    it 'is invalid without a dish' do
      tag_dish = TagDish.new(dish: nil)
      expect(tag_dish).not_to be_valid
      expect(tag_dish.errors.include?(:dish)).to be true
    end
  end

  describe 'associations' do
    it 'belongs to a dish' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste Corp', doc_number: CNPJ.generate,
        email: 'restaurant@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(
        name: 'Prato Principal', description: 'Descrição do prato principal',
        calories: 500, restaurant: restaurant
      )

      tag = Tag.create!(name: 'Especial', restaurant: restaurant)
      dish.tags << tag

      expect(dish.tag_dishes.map(&:tag)).to include(tag)
      expect(dish).to respond_to(:tag_dishes)
    end

    it 'belongs to a tag' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste Corp', doc_number: CNPJ.generate,
        email: 'restaurant@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      dish = Dish.create!(
        name: 'Prato Secundário', description: 'Descrição do prato secundário',
        calories: 300, restaurant: restaurant
      )

      tag = Tag.create!(name: 'Favorito', restaurant: restaurant)

      dish.tags << tag

      expect(tag.tag_dishes.map(&:dish)).to include(dish)
      expect(tag).to respond_to(:tag_dishes)
    end
  end
end
