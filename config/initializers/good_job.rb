Rails.application.configure do
  config.good_job.on_thread_error = ->(exception) { Raven.capture_exception(exception) }

  config.to_prepare do
    ActionMailer::MailDeliveryJob.retry_on StandardError, wait: :exponentially_longer, attempts: Float::INFINITY
  end

  if Rails.env.production? || Rails.env.staging?
    config.good_job.execution_mode = :async
    config.good_job.poll_interval = 30

    config.good_job.cron = {
      process_feed_reminders: {
        cron: '0 * * * *',
        class: 'ProcessFeedRemindersJob',
        description: "Send out hourly reminders for feeds",
      }
    }
  end
end
