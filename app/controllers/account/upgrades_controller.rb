# frozen_string_literal: true

module Account
  class UpgradesController < ApplicationController
    before_action -> { @meta_title = 'Upgrade' }
    layout 'account'

    def show
    end

    def update
      current_user.touch(:upgrade_info_at) if current_user.upgrade_info_at.blank?
      redirect_to action: :show
    end
  end
end
