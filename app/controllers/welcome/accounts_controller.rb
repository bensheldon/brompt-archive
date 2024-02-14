# frozen_string_literal: true
module Welcome
  class AccountsController < ApplicationController
    before_action :redirect_if_setup

    def edit
      @user = current_user
    end

    def update
      @user = current_user
      @user.attributes = user_params

      @user.instance_variable_set(:@bypass_confirmation_postpone, true)
      if @user.save(context: :welcome_password)
        bypass_sign_in(@user)
        @user.send_confirmation_instructions unless @user.confirmed?
        redirect_to welcome_confirm_path
      else
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end

    def redirect_if_setup
      redirect_to onboarding_redirection_path if current_user.blank? || current_user.email.present? || current_user.encrypted_password.present?
    end
  end
end
