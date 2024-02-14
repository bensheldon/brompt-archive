# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemindersController, type: :controller do
  describe '#destroy' do
    let!(:reminder) { create(:reminder) }

    it 'deletes the reminder' do
      expect do
        delete :destroy, params: { id_token: reminder.id_token }
      end.to change(Reminder, :count).by(-1)
    end

    it 'redirects to the frontpage with a message' do
      delete :destroy, params: { id_token: reminder.id_token }

      expect(response).to redirect_to root_path
      expect(flash[:notice]).to be_present
    end
  end
end
