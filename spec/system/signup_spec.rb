# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sign up", :js, type: :system do
  let(:email_address) { 'test_user@example.com' }
  let(:first_name) { 'Ursula' }
  let(:feed_url) { 'https://example.com/feed.xml' }
  let(:password) { 'password' }
  let(:sample_feed) { file_fixture("rss.xml").read }

  before do
    WebMock.stub_request(:any, feed_url).to_return(
      body: sample_feed,
      status: 200,
      headers: { last_modified: 30.days.ago, 'content-type': '' }
    )
  end

  specify 'complete onboarding flow' do
    visit root_path

    on_page do
      dev_screenshot('signup/00_homepage')
      click_on "Get started"
    end

    on_page do
      dev_screenshot('signup/01_feed')
      fill_in 'Feed URL', with: feed_url
      click_button 'Review your writing'
    end

    on_page do
      dev_screenshot('signup/02_goal')
      choose 'Once a week'
      click_button "Set your goal"
    end

    on_page do
      fill_in 'First name', with: first_name
      # TODO: some info about their writing goals, intentions, purpose
      click_button "That's me"
    end

    on_page do
      dev_screenshot('signup/03_account')
      fill_in 'Email', with: email_address
      fill_in 'Password', with: password
      click_button 'Create account'
    end

    on_page do
      dev_screenshot('signup/04_confirm')
      expect(page).to have_content 'Check your email'
    end

    open_email email_address
    current_email.click_link 'Confirm email address'

    on_page do
      dev_screenshot('signup/05_done')
      expect(page).to have_content 'Hurray!'
      click_on 'Manage goals'
    end

    user = User.first
    expect(user).to have_attributes(
      email: email_address,
      first_name: first_name
    )
    expect(user.encrypted_password).to be_present

    reminder = Reminder.first
    expect(reminder).to have_attributes(
      feed_url: feed_url,
      remind_after_days: 7,
      repeat_remind_after_days: 7
    )

    on_page do
      dev_screenshot('signup/06_account')
      expect(page).to have_content reminder.feed.title
      expect(user.reload.upgrade_info_at).to be_nil
      click_on 'Upgrade'
    end

    on_page do
      dev_screenshot('signup/07_upgrade')
      expect(page).to have_content 'Upgrade'
      expect(user.reload.upgrade_info_at).to be_within(10.seconds).of Time.current
    end
  end

  specify 'user is already signed in' do
    user = create(:user)

    sign_in user, password: 'password'

    visit new_welcome_feed_path

    on_page do
      fill_in 'Feed URL', with: feed_url
      click_button 'Review your writing'
    end

    on_page do
      choose 'Once a week'
      click_button "Set your goal"
    end

    expect(user.reminders.count).to eq 1

    on_page do
      expect(page).to have_content 'Hurray!'
    end
  end

  context 'when the email has already been registered' do
    before do
      visit new_welcome_feed_path

      on_page do
        fill_in 'Feed URL', with: feed_url
        click_button 'Review your writing'
      end

      on_page do
        choose 'Once a week'
        click_button "Set your goal"
      end

      on_page do
        fill_in 'First name', with: first_name
        click_button "That's me"
      end

      on_page do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: password
        click_button 'Create account'
      end
    end

    context 'when account is unconfirmed' do
      let!(:user) { create(:user, :unconfirmed, email: email_address, password: password) }

      specify 'user is asked to confirm' do
        on_page do
          click_on 'Confirm your email'
        end

        on_page do
          expect(page).to have_field('Email', with: user.email)
          click_on 'Confirm my email'
        end

        open_email email_address
        current_email.click_link 'Confirm email address'

        on_page do
          expect(page).to have_content 'Hurray!'
        end
      end
    end

    context 'when account is missing a password' do
      let!(:user) { create(:user, email: email_address, password: nil) }

      specify 'user is asked to reset password' do
        on_page do
          click_on 'Reset your password'
        end

        on_page do
          expect(page).to have_field('Email', with: user.email)
          click_on 'Send me reset password instructions'
        end

        open_email email_address
        current_email.click_link 'Change my password'

        on_page do
          fill_in 'New password', with: password
          click_on 'Change my password'
        end

        on_page do
          expect(page).to have_current_path(account_reminders_path)
        end
      end
    end
  end
end
