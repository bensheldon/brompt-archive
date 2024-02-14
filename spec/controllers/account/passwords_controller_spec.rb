# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account::PasswordsController, type: :controller do
  describe '#new' do
    context 'when signed in' do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it 'redirects to the account page' do
        expect do
          get :new
        end.not_to change { controller.send(:current_user) }

        expect(response).to redirect_to account_reminders_path
      end

      context 'when ?sign_out=true' do
        it 'signs out the user and redirects' do
          expect do
            get :new, params: { sign_out: true }
          end.to change { controller.send(:current_user) }.to nil

          expect(response).to redirect_to new_user_password_path
        end
      end
    end
  end
end
