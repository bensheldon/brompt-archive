# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feed, type: :model do
  it 'has a valid factory' do
    expect do
      feed = build(:feed)
      feed.save!
    end.not_to raise_error
  end

  describe '.fetch_ready' do
    let!(:recent_feed) { create(:feed, fetched_at: 5.minutes.ago, title: 'recent') }
    let!(:fetchable_feed) { create(:feed, fetched_at: 10.hours.ago, title: 'fetchable') }
    let!(:unfetched_feed) { create(:feed, fetched_at: nil, title: 'unfetched') }

    it 'returns older and unfetched feeds' do
      expect(described_class.fetch_ready.map(&:title)).to match_array([fetchable_feed, unfetched_feed].map(&:title))
    end
  end

  describe 'feed items association' do
    let!(:feed) { create(:feed) }
    let!(:other_feed) { create(:feed, :with_items) }
    let!(:second_item) { create(:feed_item, feed: feed, published_at: 5.days.ago) }
    let!(:first_item) { create(:feed_item, feed: feed, published_at: 2.days.ago) }
    let!(:third_item) { create(:feed_item, feed: feed, published_at: 6.days.ago) }

    describe '.recent_items' do
      it 'shows most recent items' do
        expect(feed.recent_items).to eq [first_item, second_item, third_item]
      end
    end

    describe '.latest_item' do
      it 'shows most recent item' do
        expect(feed.latest_item).to eq first_item
      end
    end
  end
end
