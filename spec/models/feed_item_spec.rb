# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedItem, type: :model do
  subject(:feed_item) { create(:feed_item) }

  it 'has a valid factory' do
    expect do
      feed = build(:feed_item)
      feed.save!
    end.not_to raise_error
  end

  describe '#feed' do
    it 'has a Feed association' do
      expect(feed_item.feed).to be_a Feed
    end
  end
end
