# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchFeedService, type: :service do
  let(:feed) { create(:feed) }
  let(:sample_feed) { file_fixture("rss.xml").read }

  before do
    WebMock.stub_request(:any, feed.url)
           .to_return(body: sample_feed)
  end

  describe '#call' do
    it 'updates feed and feed items' do
      described_class.new.call feed
      feed.save!

      expect(feed.title).to eq 'XML.com'
      expect(feed.items.count).to eq 3

      # expect it to update items when refetched
      expect do
        described_class.new.call feed
        feed.save!
        feed.reload
      end.not_to change { feed.items.count }
    end

    context 'when it errors' do
      before do
        WebMock.stub_request(:any, feed.url)
               .to_return(status: 404)
      end

      it 'adds the error to the feed' do
        Timecop.freeze do
          described_class.new.call feed
          feed.save!

          expect(feed.errored_at).to be_within(1.second).of Time.current
          expect(feed.error_message).to eq 'Fetch failed - 404'
          expect(feed.fetched_at).to be_within(1.second).of Time.current
        end
      end

      context 'when it had previously errored' do
        it 'updates the error message but not the timestamp' do
          Timecop.freeze do
            feed.update! errored_at: 5.days.ago, error_message: 'old error'

            described_class.new.call feed
            feed.save!

            expect(feed.errored_at).to be_within(1.second).of 5.days.ago
            expect(feed.error_message).to eq 'old error'
          end
        end
      end
    end

    context 'when it had errored but now works' do
      it 'clears out previous errors' do
        described_class.new.call feed
        feed.save!

        expect(feed.fetched_at).to be_within(1.second).of Time.current
        expect(feed.errored_at).to be_nil
        expect(feed.error_message).to be_nil
      end
    end
  end
end
