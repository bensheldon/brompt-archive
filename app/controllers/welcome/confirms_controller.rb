# frozen_string_literal: true
module Welcome
  class ConfirmsController < ApplicationController
    before_action :redirect_to_onboarding_path

    def show
    end
  end
end
