# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  retry_on StandardError, wait: :exponentially_longer, attempts: Float::INFINITY

  JobTimeoutError = Class.new(StandardError)
  around_perform do |_job, block|
    Timeout.timeout(10.minutes, JobTimeoutError) do
      block.call
    end
  end
end
