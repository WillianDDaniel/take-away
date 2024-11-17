require 'rails_helper'

describe 'Restaurants API' do
  context 'GET /api/v1/restaurants/:code' do
    it 'should show a restaurant name' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      restaurant = Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      get "/api/v1/restaurants/#{restaurant.code}"

      res = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(res['brand_name']).to include('Teste')
    end

    it 'should show a error message if the restaurant code is not valid' do
      user = User.create!(
        email: 'johndoe@example.com', name: 'John', last_name: 'Doe',
        password: 'password12345', document_number: CPF.generate
      )

      Restaurant.create!(
        brand_name: 'Teste', corporate_name: 'Teste', doc_number: CNPJ.generate,
        email: 'johndoe@example.com', phone: '11999999999', address: 'Rua Teste', user: user
      )

      get "/api/v1/restaurants/invalid_code"

      res = JSON.parse(response.body)

      expect(response).to have_http_status(404)
      expect(res['error']).to include('Restaurante não encontrado')
      expect(res['message']).to include('Verifique o código do restaurante e tente novamente')
    end
  end
end