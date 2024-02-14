# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account", type: :system do
  let!(:user) { create(:user, password: 'password') }
  let!(:reminder) { create(:reminder, :with_feed, user: user) }

  it 'allows logging in and managing reminders' do
    visit new_user_session_path

    on_page do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Sign in'
    end

    on_page do
      click_on 'Edit'
    end

    expect(page).to have_current_path account_reminder_path(reminder.id)
  end

  describe 'email and password management' do
    it 'resets password' do
      visit new_user_session_path

      on_page do
        click_on 'Forgot your password?'
      end

      on_page do
        dev_screenshot('account/reset_password/01_request_reset')

        fill_in 'Email', with: user.email
        click_on 'Send me reset password instructions'
      end

      open_email user.email
      current_email.click_link 'Change my password'

      new_password = 'newpassword'

      on_page do
        fill_in 'New password', with: new_password
        click_on 'Change my password'
      end

      # Expect to be signed in
      expect(page).to have_current_path account_reminders_path

      # TODO: logout and try to log in again
    end

    it 'changes email' do
      new_email = 'newemail@example.com'

      visit new_user_session_path

      on_page do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_on 'Sign in'
      end

      on_page do
        click_on 'Settings'
      end

      on_page do
        fill_in 'Email', with: new_email
        click_on 'Update'
      end

      expect(user.reload.email).not_to eq new_email

      on_page do
        expect(page).to have_content "Current password can't be blank"
        fill_in 'Email', with: new_email
        fill_in 'Current password', with: 'password'
        click_on 'Update'
      end

      open_email new_email
      current_email.click_link 'Confirm email address'

      expect(user.reload.email).to eq new_email
      expect(page).to have_current_path edit_account_settings_path
    end

    it 'changes password' do
      new_password = "newpassword"

      visit new_user_session_path

      on_page do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_on 'Sign in'
      end

      on_page do
        click_on 'Settings'
      end

      expect do
        on_page do
          fill_in 'Password', with: new_password
          click_on 'Update'
        end
      end.not_to change(user, :encrypted_password)

      on_page do
        expect(page).to have_content "Current password can't be blank"
        fill_in 'Password', with: new_password
        fill_in 'Current password', with: 'password'
        click_on 'Update'
      end

      on_page do
        click_on 'Sign out'
      end

      visit new_user_session_path

      on_page do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: new_password
        click_on 'Sign in'
      end

      expect(page).to have_current_path account_reminders_path
    end
  end

  describe 'admin navigation' do
    let!(:admin) { create(:user, password: 'password', is_admin: true) }

    it 'is NOT visible to non-admins' do
      visit new_user_session_path

      on_page do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_on 'Sign in'
      end

      expect(page).to have_no_content 'Admin'
    end

    it 'is visible to non-admins' do
      visit new_user_session_path

      on_page do
        fill_in 'Email', with: admin.email
        fill_in 'Password', with: admin.password
        click_on 'Sign in'
      end

      expect(page).to have_content 'Admin'
    end
  end
end
