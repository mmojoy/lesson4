require 'rails_helper'

RSpec.feature 'List', type: :feature do
	let!(:user) { create(:user) }

	feature 'List created' do
		background do
			visit root_path
			within 'form' do
				fill_in 'Email', with: user.email
				fill_in 'Password', with: user.password
			end
			click_button 'Sign in'
		end

		scenario "success created list", js: true do
			within 'form' do
				fill_in :list_title, with: 'testlist'
			end
			click_button 'Create List'
			expect(page).to have_text('testlist')
		end

		scenario "fails created list", js: true do
			click_button 'Create List'
			expect(page).to have_text('Invalid list name')
		end
	end
end