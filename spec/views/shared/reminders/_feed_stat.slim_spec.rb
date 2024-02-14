# frozen_string_literal: true

require "rails_helper"

RSpec.describe "shared/reminders/feed_stat" do
  let(:feed) { create(:feed) }
  let(:feed_stat) { FeedStat.new(feed) }

  def render_partial
    render partial: 'shared/reminders/feed_stat', locals: { feed_stat: feed_stat }
  end

  context 'when feed has no items' do
    specify do
      render_partial
      expect(rendered).to match "We didn’t find any items in your sites feed. It doesn’t look like you’ve published anything yet."
    end
  end

  context 'when feed has 1 item' do
    before do
      create(:feed_item, feed: feed, published_at: 3.days.ago)
    end

    specify do
      render_partial
      expect(rendered).to match "Your feed only has one item. It’s been 3 days since you last posted."
    end
  end

  context 'when feed has 3 items' do
    before do
      create(:feed_item, feed: feed, published_at: 2.days.ago)
      create(:feed_item, feed: feed, published_at: 4.days.ago)
      create(:feed_item, feed: feed, published_at: 7.days.ago)
    end

    specify do
      render_partial
      expect(rendered).to match(
        "You publish on average every 3 days, based on your last 3 posts. " \
        "The longest time period between posts is 3 days. " \
        "It’s been 2 days since you last posted."
      )
    end
  end
end
