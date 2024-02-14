# frozen_string_literal: true

class ProcessFeedRemindersJob < ApplicationJob
  def perform
    ProcessFeedRemindersService.new.call
  end
end
