# frozen_string_literal: true
require "capybara/cuprite"

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1024, 800],
    js_errors: false,
    headless: !ENV['SHOW_BROWSER'],
    process_timeout: 30,
    browser_options: {
      'no-sandbox': nil,
      'disable-dev-shm-usage': nil,
    }
  )
end

Capybara.default_max_wait_time = 2
Capybara.server = :puma, { Silent: true }
Capybara.javascript_driver = :cuprite

RSpec.configure do |config|
  config.before(:each, type: :system) do |example|
    if ENV['SHOW_BROWSER']
      example.metadata[:js] = true
      driven_by :cuprite
    else
      driven_by :rack_test
    end
  end

  config.before(:each, :js, type: :system) do
    # Chrome's no-sandbox option is required for running in Docker
    driven_by :cuprite
  end

  config.around(type: :system) do |example|
    old_mailer_options = ActionMailer::Base.default_url_options
    example.run
    ActionMailer::Base.default_url_options = old_mailer_options
  end

  config.before(type: :system) do |example|
    next unless example.metadata[:js] || ENV['SHOW_BROWSER']

    ActionMailer::Base.default_url_options = {
      host: Capybara.current_session.server.host,
      port: Capybara.current_session.server.port,
    }
  end
end
