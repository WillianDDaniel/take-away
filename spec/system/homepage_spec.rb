require 'rails_helper'

describe 'Homepage' do

  context 'when visiting the homepage' do

    it 'user see a title/logo on navbar' do
      visit root_path

      within('nav') do
        expect(page).to have_link('Palevá')
      end
    end

    it 'user see the login link on navbar' do
      visit root_path

      within('nav') do
        expect(page).to have_link('Entrar')
      end
    end

    it 'user see the signup link on navbar' do
      visit root_path

      within('nav') do
        expect(page).to have_link('Criar conta')
      end
    end

    it 'user see the welcome message' do
      visit root_path

      expect(page).to have_content('Boas vindas ao Palevá')
    end

    it 'user see the site description' do
      visit root_path

      expect(page).to have_content('O melhor sistema de controle de pedidos para restaurantes')
    end
  end
end