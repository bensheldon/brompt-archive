# frozen_string_literal: true

module Account
  class SettingsController < Devise::RegistrationsController
    before_action -> { @meta_title = 'Settings' }
    layout 'account'

    def edit
    end

    private

    def after_update_path_for(_resource)
      edit_account_settings_path
    end
  end
end
