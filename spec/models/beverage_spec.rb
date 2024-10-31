require 'rails_helper'

RSpec.describe Beverage, type: :model do

  describe '#valid?' do
    it 'must have a name' do
      beverage = Beverage.new(description: 'Cerveja lata', calories: 200, alcoholic: true)

      expect(beverage.valid?).to be false
      expect(beverage.errors.include?(:name)).to be true
    end

    it 'must have a restaurant_id' do
      beverage = Beverage.new(name: 'Cerveja', description: 'Cerveja lata', calories: 200, alcoholic: true)

      expect(beverage.valid?).to be false
      expect(beverage.errors.include?(:restaurant)).to be true
    end
  end

  describe '#set_default_alcoholic' do
    it 'should set default value for alcoholic' do
      beverage = Beverage.new
      beverage.set_default_alcoholic
      expect(beverage.alcoholic).to be false
    end
  end

  describe 'status' do
    it 'should have a default status of active' do
      beverage = Beverage.new(name: 'Cerveja', description: 'Cerveja lata', calories: 200)

      expect(beverage.status).to eq('active')
    end

    it 'should only allow valid statuses' do
      beverage = Beverage.new(name: 'Cerveja', description: 'Cerveja lata', calories: 200)
      expect { beverage.status = 'invalid_status' }.to raise_error(ArgumentError)
    end

    it 'should allow active and paused status to be set' do
      beverage = Beverage.new(name: 'Cerveja', description: 'Cerveja lata', calories: 200)

      beverage.status = 'active'
      expect(beverage.status).to eq('active')
      expect(beverage.errors.include?(:status)).to be false

      beverage.status = 'paused'
      expect(beverage.status).to eq('paused')
      expect(beverage.errors.include?(:status)).to be false
    end
  end

  describe 'calories' do
    it 'should have a non-negative number of calories' do
      beverage = Beverage.new(name: 'Cerveja', description: 'Cerveja lata', calories: -50, alcoholic: true)

      expect(beverage.valid?).to be false
      expect(beverage.errors.include?(:calories)).to be true
    end
  end
end
