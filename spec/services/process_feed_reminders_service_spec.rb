# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessFeedRemindersService, type: :service do
  let!(:feed) { create(:feed) }
  let(:sample_feed) { file_fixture("rss.xml").read }

  before do
    WebMock.stub_request(:any, feed.url).to_return \
      body: sample_feed,
      status: 200,
      headers: { last_modified: Time.zone.now }
  end

  describe '#call' do
    it 'updates feed and feed items' do
      FetchFeedService.new.call feed
      feed.save!

      expect(feed.title).to eq 'XML.com'
      expect(feed.items.count).to eq 3

      # expect it to update items when refetched
      expect do
        FetchFeedService.new.call feed
        feed.save!
        feed.reload
      end.not_to change { feed.items.count }
    end
  end
end
