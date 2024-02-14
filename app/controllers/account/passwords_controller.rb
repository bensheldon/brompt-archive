# frozen_string_literal: true

module Account
  class PasswordsController < Devise::PasswordsController
    before_action -> { @meta_title = 'Account password' }
    skip_before_action :require_no_authentication, if: -> { action_name == 'new' && params[:sign_out].present? }

    def new
      if params[:sign_out].present? && current_user.present?
        sign_out(current_user)
        return redirect_to new_user_password_path(params.permit(:email))
      end

      self.resource = User.new
      resource.email = params[:email] if params[:email].present?
    end
  end
end
