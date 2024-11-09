require 'rails_helper'

RSpec.describe Schedule, type: :model do

  describe '#valid?' do
    it 'is invalid without an open_time' do
      user = User.create!(
        email: 'johndoe@example.com',
        name: 'John',
        last_name: 'Doe',
        password: 'password12345',
        document_number: CPF.generate
      )

      restaurant = Restaurant.create!(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      schedule = Schedule.new(close_time: '18:00', week_day: 1, restaurant: restaurant)

      expect(schedule.valid?).to be false
      expect(schedule.errors.include?(:open_time)).to be true
    end

    it 'is invalid without a close_time' do
      user = User.create!(
        email: 'johndoe@example.com',
        name: 'John',
        last_name: 'Doe',
        password: 'password12345',
        document_number: CPF.generate
      )

      restaurant = Restaurant.create!(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      schedule = Schedule.new(open_time: '09:00', week_day: 1, restaurant: restaurant)

      expect(schedule.valid?).to be false
      expect(schedule.errors.include?(:close_time)).to be true
    end

    it 'is invalid without a week_day' do
      user = User.create!(
        email: 'johndoe@example.com',
        name: 'John',
        last_name: 'Doe',
        password: 'password12345',
        document_number: CPF.generate
      )

      restaurant = Restaurant.create!(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      schedule = Schedule.new(open_time: '09:00', close_time: '18:00', restaurant: restaurant)

      expect(schedule.valid?).to be false
      expect(schedule.errors.include?(:week_day)).to be true
    end

    it 'is invalid if open_time is after or equal to close_time' do
      user = User.create!(
        email: 'johndoe@example.com',
        name: 'John',
        last_name: 'Doe',
        password: 'password12345',
        document_number: CPF.generate
      )

      restaurant = Restaurant.create!(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      schedule = Schedule.new(open_time: '18:00', close_time: '09:00', week_day: 1, restaurant: restaurant)

      expect(schedule.valid?).to be false
      expect(schedule.errors.include?(:open_time)).to be true
      expect(schedule.errors[:open_time]).to include('deve ser menor que o horário de fechamento')
    end

    it 'is valid with valid attributes' do
      user = User.create!(
        email: 'johndoe@example.com',
        name: 'John',
        last_name: 'Doe',
        password: 'password12345',
        document_number: CPF.generate
      )

      restaurant = Restaurant.create!(brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      schedule = Schedule.new(open_time: '09:00', close_time: '18:00', week_day: 1, restaurant: restaurant)

      expect(schedule.valid?).to be true
    end
  end

  describe '.day_options' do
    it 'returns an array of day names and indices' do
      expected_day_options = I18n.t('date.day_names').map.with_index { |day, index| [day, index] }

      expect(Schedule.day_options).to eq(expected_day_options)
    end
  end
end
