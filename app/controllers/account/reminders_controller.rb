# frozen_string_literal: true

module Account
  class RemindersController < ApplicationController
    before_action :not_authorized, unless: :current_user
    layout 'account'

    def index
      @user = current_user
      @reminders = @user.reminders.includes(feed: [:recent_items])
    end

    def new
      @reminder = Reminder.new
    end

    def edit
      @reminder = current_user.reminders.find(params[:id])
    end

    def create
      @reminder = Reminder.new(reminder_create_params.merge(user: current_user))
      feed_is_valid = ValidateReminderFeedService.new(@reminder).call

      if feed_is_valid && @reminder.save
        redirect_to account_reminders_path, notice: 'Goal has been created.'
      else
        render :edit
      end
    end

    def update
      @reminder = current_user.reminders.find(params[:id])

      if @reminder.update(reminder_update_params)
        redirect_to edit_account_reminder_path(@reminder.id), notice: 'Reminder was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @reminder = current_user.reminders.find(params[:id])

      if @reminder.destroy
        redirect_to account_reminders_path, notice: 'Goal has been deleted.'
      else
        render :edit
      end
    end

    private

    def reminder_create_params
      params.require(:reminder).permit(:feed_url, :remind_after_days, :repeat_remind_after_days)
    end

    def reminder_update_params
      params.require(:reminder).permit(:remind_after_days, :repeat_remind_after_days)
    end
  end
end
