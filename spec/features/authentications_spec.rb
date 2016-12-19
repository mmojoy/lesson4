require 'rails_helper'

RSpec.feature 'Authentication', type: :feature, js: true do
  given!(:user) { create(:user, email: 'some@gmail.com') }

  feature 'Sign In' do
    background do
      visit root_path
    end

    scenario 'fails with invalid credentials' do
      click_button 'Sign in'
      expect(page).to have_text('incorrect')
    end

    scenario 'success with valid credentials' do
      within 'form' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
      end
      click_button 'Sign in'
      expect(page).to have_text('Signed in as')
      click_link 'Logout'
      expect(page).to have_text('Login')
    end
  end

  feature 'Sign Up' do
    given!(:list) { create(:list) }
    given!(:pending) { PendingEmail.create(email: 'email@gmail.com', list_id: list.id) }

    background do
      visit root_path
      click_link 'Signup'
    end

    scenario 'fails with invalid credentials' do
      click_button 'Create user'
      expect(page).to have_text("Password can't be blank")
    end

    scenario 'success with valid credentials' do
      within 'form' do
        fill_in 'Name', with: 'name'
        fill_in 'Email', with: 'email@gmail.com'
        fill_in 'Password', with: '12345678'
        fill_in 'Password confirmation', with: '12345678'
      end
      click_button 'Create user'
      expect(page).to have_text('You signed up successfully')
    end
  end
end
