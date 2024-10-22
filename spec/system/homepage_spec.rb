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

  context 'when clicking on menu links' do

    it 'user goes to login page' do
      visit root_path

      within('nav') do
        click_on 'Entrar'
      end

      expect(current_path).to eq new_user_session_path
    end

    it 'user goes to signup page' do
      visit root_path

      within('nav') do
        click_on 'Criar conta'
      end

      expect(current_path).to eq new_user_registration_path
    end

    it 'user stays on homepage' do
      visit root_path

      within('nav') do
        click_on 'Palevá'
      end

      expect(current_path).to eq root_path
    end
  end
end