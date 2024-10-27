require 'rails_helper'

describe 'Homepage' do

  context 'when visiting the homepage' do

    it 'user see a logo with a link on navbar' do
      visit root_path

      within('nav') do
        expect(page).to have_link('PaLevá')
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

    it 'user see the logo on header' do
      visit root_path

      expect(page).to have_content('PaLevá')
    end

    it 'user see the site subtitle on header' do
      visit root_path

      expect(page).to have_content('O Controle Total do Seu Cardápio')
    end

    it 'user see the site description on header' do
      visit root_path

      description = <<~DESCRIPTION.squish
        PaLevá é o seu parceiro para um gerenciamento de menu eficiente e intuitivo.
        Crie, edite e organize todos os itens do seu cardápio de maneira prática.
      DESCRIPTION

      expect(page).to have_content(description)
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
        click_on 'PaLevá'
      end

      expect(current_path).to eq root_path
    end
  end

  context 'when clicking on header links' do

    it 'user goes to login page' do
      visit root_path

      within('header') do
        click_on 'Entrar'
      end

      expect(current_path).to eq new_user_session_path
    end

    it 'user goes to signup page' do
      visit root_path

      within('header') do
        click_on 'Criar Conta'
      end

      expect(current_path).to eq new_user_registration_path
    end
  end
end