# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedRemindersJob do
  let(:reminder) { create(:reminder) }
  let(:feed) { create(:feed, reminders: [reminder]) }
  let(:feed_one_item) { file_fixture("one_item.xml").read }
  let(:feed_two_items) { file_fixture("two_items.xml").read }

  before do
    WebMock.stub_request(:any, feed.url).to_return(
      {
        body: feed_one_item,
        status: 200,
        headers: { last_modified: 30.days.ago },
      },
      body: feed_two_items,
      status: 200,
      headers: { last_modified: Time.current }
    )
  end

  it 'fetches feed and sends messages' do
    expect do
      Timecop.travel 30.days.ago do
        described_class.perform_now(feed.reload)

        open_email(reminder.user.email)
        expect(current_email.body).to include("http://www.xml.com/pub/a/2002/12/04/svg.html")
      end

      clear_emails
      described_class.perform_now(feed.reload)

      open_email(reminder.user.email)
      expect(current_email.body).not_to include("http://www.xml.com/pub/a/2002/12/04/svg.html")
      expect(current_email.body).to include("http://www.xml.com/pub/a/2002/12/05/som.html")
    end.to change(reminder.messages, :count).by(2)
  end

  context 'when the feed has errors' do
    it 'does not send emails' do
      Timecop.travel 30.days.ago do
        described_class.perform_now(feed.reload)

        open_email(reminder.user.email)
        expect(current_email.body).to include("http://www.xml.com/pub/a/2002/12/04/svg.html")
      end

      clear_emails
      WebMock.stub_request(:any, feed.url).to_raise(StandardError)

      described_class.perform_now(feed.reload)

      open_email(reminder.user.email)
      expect(current_email).to be_nil
    end
  end
end
