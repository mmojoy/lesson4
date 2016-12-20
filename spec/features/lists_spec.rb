require 'rails_helper'

RSpec.feature 'Lists', type: :feature, js: true do
  given!(:user) { create(:user) }
  given!(:list) { create(:list, user: user) }

  background do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit root_path
  end

  feature 'Create list' do
    scenario 'success with valid credentials', js: true do
      within 'form.new_list' do
        fill_in 'list[title]', with: 'list title'
      end
      click_button('Create List')
      expect(page).to have_text('list title')
    end
  end

  feature 'Share list' do
    given!(:user_one) { create(:user, email: 'user_one@gmail.com') }
    given!(:user_two) { create(:user, email: 'user_two@gmail.com') }
    given!(:list) { create(:list, user: user, users: [user_two]) }

    background do
      visit list_tasks_path(list)
    end

    scenario 'Share list with existing user' do
      within first('form') do
        fill_in 'email', with: user_one.email
      end
      click_button('Send')
      expect(page).to have_text('Email is sent to user')
    end

    scenario 'Invite nonexisting user to app' do
      within first('form') do
        fill_in 'email', with: 'email@gmail.com'
      end
      click_button('Send')
      expect(page).to have_text('Email is sent to user')
    end

    scenario 'Share list with coowner' do
      within first('form') do
        fill_in 'email', with: user_two.email
      end
      click_button('Send')
      expect(page).to have_text('This user is already added to the list')
    end
  end

  feature 'Destroy list' do
    scenario 'remove list' do
      find("#list_#{list.id} a", text: '×').click
      expect(page).to_not have_text(list.title)
    end
  end
end
