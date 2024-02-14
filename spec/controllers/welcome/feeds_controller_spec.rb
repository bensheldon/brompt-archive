# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Welcome::FeedsController, type: :controller do
  let(:feed_url) { 'https://example.com/feed.xml' }
  let(:sample_feed) { file_fixture("rss.xml").read }

  before do
    WebMock.stub_request(:any, feed_url).to_return(
      body: sample_feed,
      status: 200,
      headers: { last_modified: 30.days.ago, 'content-type': '' }
    )
  end

  describe '#new' do
    it 'fetches feed items and does not save' do
      RSpec::Matchers.define_negated_matcher :not_change, :change

      expect do
        get :new, params: { url: feed_url }
      end.to not_change(Reminder, :count).and not_change(Feed, :count).and not_change(FeedItem, :count)
    end
  end
end
