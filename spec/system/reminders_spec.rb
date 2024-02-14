# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Reminders management", type: :system do
  let!(:user) { create(:user) }
  let!(:feed) { create(:feed) }
  let!(:reminder) { create(:reminder, feed_url: feed.url, feed: feed) }
  let(:reminder_attributes) { attributes_for(:reminder) }
  let(:sample_feed) { file_fixture("rss.xml").read }
  let(:feed_title) { 'XML.com' }
  let(:feed_one_item) { file_fixture("one_item.xml").read }
  let(:feed_two_items) { file_fixture("two_items.xml").read }

  def stub_one_item_feed
    WebMock.stub_request(:any, feed.url).to_return(
      body: feed_one_item,
      status: 200,
      headers: { last_modified: 30.days.ago }
    )
  end

  def stub_two_item_feed
    WebMock.stub_request(:any, feed.url).to_return(
      body: feed_two_items,
      status: 200,
      headers: { last_modified: Time.current }
    )
  end

  after do
    Timecop.return
  end

  it "User creates a new reminder" do
    stub_one_item_feed

    Timecop.travel 1.day.from_now
    ProcessFeedRemindersService.new.call

    open_email(reminder.user.email)
    expect(current_email.subject).to include feed_title
    expect(current_email.body).to include("http://www.xml.com/pub/a/2002/12/04/svg.html")

    current_email.click_link 'Change or delete'
    expect(page).to have_current_path reminder_path(reminder)

    select '5 days', from: find(:label, text: /keep reminding/)[:for]
    click_button 'Update Reminder'
    expect(page).to have_text("Reminder was successfully updated.")

    clear_emails

    Timecop.travel 1.day.from_now
    ProcessFeedRemindersService.new.call

    open_email(reminder.user.email)
    expect(current_email).to be_nil

    clear_emails

    stub_two_item_feed

    Timecop.travel 1.day.from_now
    ProcessFeedRemindersService.new.call

    open_email(reminder.user.email)
    expect(current_email).to be_nil

    clear_emails

    Timecop.travel 10.days.from_now
    ProcessFeedRemindersService.new.call

    open_email(reminder.user.email)
    expect(current_email.subject).to include('EXTRA').and include(feed_title)
    expect(current_email.body).to include("http://www.xml.com/pub/a/2002/12/05/som.html")
    current_email.click_link 'Change or delete'

    expect(page).to have_current_path reminder_path(reminder)

    click_link 'Delete'
    expect(page).to have_text 'Reminder was successfully deleted.'
    expect(Reminder).not_to exist(reminder.id)
  end
end
