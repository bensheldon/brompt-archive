# frozen_string_literal: true

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.after do
    # Necessary for ensuring consistent Percy screenshots
    FactoryBot.rewind_sequences
  end
end
