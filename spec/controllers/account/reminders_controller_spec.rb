# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account::RemindersController, type: :controller do
  render_views

  let!(:user) { create(:user) }
  let!(:reminder) { create(:reminder, user: user) }

  describe '#edit' do
    specify do
      sign_in user

      get :edit, params: { id: reminder.id }

      expect(assigns(:reminder)).to eq reminder
    end
  end

  describe '#update' do
    specify do
      sign_in user

      expect do
        put :update, params: { id: reminder.id, reminder: { remind_after_days: 14, repeat_remind_after_days: reminder.repeat_remind_after_days } }
      end.to change { reminder.reload.remind_after_days }.from(7).to(14)
    end
  end

  describe '#create' do
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
      sign_in user

      expect do
        post :create, params: { reminder: { feed_url: feed_url } }
      end.to change(Reminder, :count).by(1)
    end
  end
end
