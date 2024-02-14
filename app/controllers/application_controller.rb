# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  alias devise_current_user current_user
  def current_user
    return @current_user if instance_variable_defined?(:@current_user)

    @current_user = devise_current_user || nil # TODO: use activenull
  end

  def not_authorized
    return render(json: {}, status: :unauthorized) if request.xhr?

    if current_user.present?
      # convert 401/403 to 404 error
      raise ActionController::RoutingError.new('Not Found'), $ERROR_INFO.to_s, $ERROR_INFO.backtrace
    end

    store_location_for :user, request.url
    redirect_to new_user_session_path, notice: 'You must sign in to access this page.'
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || account_reminders_path
  end

  def onboarding_redirection_path(user = current_user)
    reminder = user.reminders.first if user.present?

    return welcome_done_path if user.present? && user.confirmed?

    if user.blank? || reminder.blank?
      new_welcome_feed_path
    elsif user.first_name.blank?
      edit_welcome_name_path
    elsif user.email.blank? || user.encrypted_password.blank?
      edit_welcome_account_path
    elsif user.confirmed_at.blank?
      welcome_confirm_path
    else
      welcome_done_path
    end
  end

  def redirect_to_onboarding_path
    redirect_path = onboarding_redirection_path
    redirect_to(redirect_path) unless redirect_path == request.fullpath
  end
end
