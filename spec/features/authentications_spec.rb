require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  let!(:user) { create(:user) }

  feature 'Sign In' do
    background do
      visit root_path
    end

    scenario 'fails with invalid credentials', js: true do
      click_button 'Sign in'
      expect(page).to have_text('incorrect')
    end

    scenario 'success with valid credentials', js: true do
      within 'form' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
      end
      click_button 'Sign in'
      expect(page).to have_text('mail@mail.com')
      click_link 'Logout'
      expect(page).to have_text('Login')
    end
  end

  feature 'Sign Up' do
    background do
      visit root_path
    end

    scenario 'fails with invalid credentials', js: true do
     click_link 'Signup'
     click_button 'Create user'
     expect(page).to have_text('blank')
   end

   scenario 'success with valid credentials', js: true do
    click_link 'Signup'
    within 'form' do
      fill_in 'Name', with: 'test'
      fill_in 'Email', with: 'test2@mail.com'
      fill_in 'Password', with: 'qwerty22'
      fill_in 'Password confirmation', with: 'qwerty22'
    end
    click_button 'Create user'
    expect(page).to have_text('successfully')
  end
end
end
