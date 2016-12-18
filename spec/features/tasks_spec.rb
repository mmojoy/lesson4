require 'rails_helper'

RSpec.feature 'Tasks', type: :feature, js: true do
  given!(:user) { create(:user) }
  given!(:list) { create(:list, user: user) }
  given!(:task) { create(:task, list: list) }

  background do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit list_tasks_path(list)
  end

  feature 'Create task' do
    scenario 'fails with invalid credentials' do
      within 'form.new_task' do
        fill_in 'task[title]', with: '11'
      end
      page.execute_script("$('form.new_task').submit()")
      expect(page).to have_selector('#tasks li', count: 1)
    end

    scenario 'success with valid credentials', js: true do
      within 'form.new_task' do
        fill_in 'task[title]', with: '111'
      end
      page.execute_script("$('form.new_task').submit()")
      expect(page).to have_selector('#tasks li', count: 2)
    end
  end

  feature 'Update task' do
    background do
      click_link(task.title)
    end

    scenario 'fails with invalid credentials' do
      within 'form.edit_task' do
        fill_in 'task[title]', with: '11'
      end
      page.execute_script("$('form.edit_task').submit()")
      expect(page).to have_text('is too short')
    end

    scenario 'success with valid credentials', js: true do
      within 'form.edit_task' do
        fill_in 'task[title]', with: '111'
      end
      page.execute_script("$('form.edit_task').submit()")
      expect(page).to have_css('#tasks li', text: '111')
    end
  end

  feature 'Destroy task' do
    scenario 'remove task' do
      find("#task_#{task.id}").hover
      find("#task_#{task.id} .delete", visible: false).click
      expect(page).to_not have_text(task.title)
    end
  end

  feature 'Update all' do
    scenario 'check all tasks' do
      find(:css, '#boss').set(true)
      # expect('#task_done').to be_checked
    end
  end

  feature 'Remove completed' do
    given!(:done_task) { create(:task, done: true, title: 'task2', list: list) }

    background do
      visit list_tasks_path(list)
    end

    scenario 'remove checked tasks' do
      click_link('Remove completed')
      expect(page).to_not have_text(done_task.title)
    end
  end
end
