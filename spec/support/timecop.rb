# frozen_string_literal: true

RSpec.configure do |config|
  config.after do |_example|
    Timecop.return
  end
end
