# frozen_string_literal: true

class RemindersController < ApplicationController
  before_action :set_reminder, only: [:show, :update, :destroy]
  before_action -> { @meta_title = 'Reminders' }
  layout :reminders_layout

  # GET /reminders/1
  def show
  end

  # PATCH/PUT /reminders/1
  def update
    @reminder.assign_attributes(reminder_params)

    if @reminder.save(context: :edit_legacy_reminder)
      redirect_to @reminder, notice: 'Reminder was successfully updated.'
    else
      render :show
    end
  end

  # DELETE /reminders/1
  def destroy
    @reminder.destroy!
    redirect_to root_path, notice: 'Reminder was successfully deleted.'
  end

  private

  def set_reminder
    @reminder = Reminder.find_by!(id_token: params[:id_token])
  end

  def reminder_params
    params.require(:reminder).permit(:feed_url, :remind_after_days, :repeat_remind_after_days)
  end

  def reminders_layout
    if current_user
      'account'
    else
      'application'
    end
  end
end
