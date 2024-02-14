# frozen_string_literal: true

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.before(type: :controller) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
end
