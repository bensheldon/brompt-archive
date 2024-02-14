# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Welcome::AccountsController, type: :controller do
  let(:user) { create(:user, :blank, first_name: 'Sara') }

  before do
    sign_in user
  end

  describe '#update' do
    it 'errors on nil values' do
      put :update, params: { user: { nothing: '' } }
      expect(assigns(:user).errors).to be_present

      put :update, params: { user: { email: '', password: '' } }
      expect(assigns(:user).errors).to be_present

      put :update, params: { user: { email: 'user@example.com', password: '' } }
      expect(assigns(:user).errors).to be_present

      put :update, params: { user: { email: '', password: 'password' } }
      expect(assigns(:user).errors).to be_present
    end

    it 'updates user email and password' do
      expect do
        put :update, params: { user: { email: 'sara@example.com', password: 'password' } }
      end.to change { user.reload.email }.from(nil).to('sara@example.com')
                                         .and change { user.reload.encrypted_password }.from(nil)
    end
  end

  context 'when not signed in' do
    before do
      sign_out user
    end

    it 'redirects back to the beginning' do
      get :edit
      expect(response).to redirect_to new_welcome_feed_path

      put :update, params: { user: { email: 'sara@example.com', password: 'password' } }
      expect(response).to redirect_to new_welcome_feed_path
    end
  end
end
