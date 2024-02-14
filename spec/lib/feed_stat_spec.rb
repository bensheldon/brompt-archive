# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedStat do
  subject(:feed_stat) { described_class.new(feed) }

  let(:feed) { create(:feed, :with_items) }

  pending "add some examples to (or delete) #{__FILE__}"
end
