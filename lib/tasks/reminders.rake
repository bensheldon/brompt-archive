# frozen_string_literal: true

namespace :reminders do
  desc 'Update reminders'
  task update: [:environment, 'log_level:info'] do |_t, _args|
    Rails.logger.info "Updating reminders"
    ProcessFeedRemindersService.new.call
  end
end
