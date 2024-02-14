# frozen_string_literal: true

module Account
  class SessionsController < Devise::SessionsController
    skip_before_action :require_no_authentication, if: -> { action_name == 'new' && params[:sign_out].present? }

    def new
      if params[:sign_out].present? && current_user.present?
        sign_out(current_user)
        return redirect_to new_user_session_path(params.permit(:email))
      end

      super do |user|
        user.email = params[:email] if params[:email].present?
      end
    end
  end
end
