# frozen_string_literal: true

module Account
  class ConfirmationsController < Devise::ConfirmationsController
    before_action -> { @meta_title = 'Account confirmation' }

    # POST /resource/confirmation

    # GET /resource/confirmation?confirmation_token=abcdef
    def show
      confirmation_digest = Devise.token_generator.digest(self, :confirmation_token, params[:confirmation_token])
      shadowed_resource = User.find_by(confirmation_token: confirmation_digest) || User.find_by(confirmation_token: params[:confirmation_token])
      @confirmed_changed_email = shadowed_resource&.unconfirmed_email.present?

      super do |resource|
        # Automatically sign in the user after they confirm their email address
        sign_in(resource) if resource.present? && resource.errors.empty?
      end
    end

    # GET /resource/confirmation/new
    def new
      if params[:sign_out].present? && current_user.present?
        sign_out(current_user)
        return redirect_to new_user_confirmation_path(params.permit(:email))
      end

      self.resource = User.new
      resource.email = params[:email] if params[:email].present?
    end

    # protected

    # The path used after resending confirmation instructions.
    def after_resending_confirmation_instructions_path_for(_resource_name)
      flash.discard :notice # don't set a flash message, use template below
      onboarding_redirection_path
    end

    # The path used after confirmation.
    def after_confirmation_path_for(_resource_name, _resource)
      flash.discard :notice # don't set a flash message, use template below

      if @confirmed_changed_email
        edit_account_settings_path
      else
        onboarding_redirection_path
      end
    end
  end
end
