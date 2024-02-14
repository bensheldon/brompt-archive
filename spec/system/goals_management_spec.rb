# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Goals management", :js, type: :system do
  let!(:user) { create(:user, password: 'password') }
  let!(:reminder) { create(:reminder, :with_feed, user: user) }
  let(:feed_url) { 'https://example.com/feed.xml' }
  let(:sample_feed) { file_fixture("rss.xml").read }

  before do
    WebMock.stub_request(:any, feed_url).to_return(
      body: sample_feed,
      status: 200,
      headers: { last_modified: 30.days.ago, 'content-type': '' }
    )
  end

  specify do
    visit new_user_session_path

    on_page do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Sign in'
    end

    click_on 'Goals'

    on_page do
      dev_screenshot('goals/01_index')

      click_on 'New Goal'
    end

    on_page do
      dev_screenshot('goals/02_create')

      fill_in 'Feed URL', with: feed_url
      select '1 day', from: 'My goal is to post every...'

      click_on 'Create goal'
    end

    on_page do
      dev_screenshot('goals/03_index_max')

      expect(page).to have_content Reminder.last.feed.title

      create_button = find("button", text: 'New Goal')
      expect(create_button[:class]).to include 'disabled'

      click_on 'Edit', match: :first
    end

    on_page do
      dev_screenshot('goals/04_edit')

      accept_confirm do
        click_on 'Delete'
      end
    end

    on_page do
      dev_screenshot('goals/05_index_after_delete')

      create_button = find("a", text: 'New Goal')
      expect(create_button[:class]).not_to include 'disabled'
    end
  end
end
