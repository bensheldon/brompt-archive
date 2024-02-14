# frozen_string_literal: true
require 'axe/rspec'

module SystemSpecHelpers
  def on_page(page_title = nil)
    expect(page.title).to include(page_title) if page_title

    begin
      take_screenshot if ENV['SCREENSHOTS'].present?
    rescue Capybara::NotSupportedByDriverError
      # ignore
    end

    # TODO: fix error: Expected "(cyclic structure)" to respond to #to_hash
    # check_accessibility

    yield
  end

  def sign_in(user, password: nil)
    visit new_user_session_path

    on_page do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password || password
      click_on 'Sign in'
    end

    expect(page).to have_current_path account_reminders_path
  end

  def dev_screenshot(name)
    return unless javascript_driver?

    page.save_screenshot(Rails.root.join("app/assets/images/dev_screenshots/#{name}.png"))
  end

  def pause
    $stderr.write 'Press enter to continue'
    $stdin.gets
  end

  def check_accessibility(scroll_to_top: true)
    return unless javascript_driver?

    expect(page).to be_accessible.skipping('color-contrast')

    page.execute_script "window.scrollTo(0,0)" if scroll_to_top
  end

  def javascript_driver?
    Capybara.current_driver == Capybara.javascript_driver
  end
end

RSpec.configure do |config|
  config.include SystemSpecHelpers, type: :system
end
