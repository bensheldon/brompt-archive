# frozen_string_literal: true

module Welcome
  class FeedsController < ApplicationController
    def new
      @reminder = Reminder.new feed_url: feed_url
      ValidateReminderFeedService.new(@reminder).call if feed_url_present?
    end

    def create
      @reminder = Reminder.new(reminder_params)
      feed_is_valid = ValidateReminderFeedService.new(@reminder).call
      return render(:new) unless feed_is_valid

      @user = current_user || create_new_user
      @reminder.user = @user

      if @reminder.save
        redirect_to onboarding_redirection_path(@user)
      else
        render :new
      end
    end

    private

    def create_new_user
      new_user = User.create! email: nil, password: nil, allow_nil_email: true
      sign_in('user', new_user)
      new_user
    end

    def feed_url
      params.dig(:reminder, :feed_url) || params[:url]
    end

    def feed_url_present?
      params.key?(:reminder) || params.key?(:url)
    end

    def reminder_params
      params.require(:reminder).permit(:feed_url, :remind_after_days)
    end
  end
end
