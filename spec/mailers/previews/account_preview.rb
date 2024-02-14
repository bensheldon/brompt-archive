# frozen_string_literal: true

class AccountPreview < ActionMailer::Preview
  def confirmation_instructions
    user = FactoryBot.create(:user)
    DeviseMailer.confirmation_instructions(user, 'token')
  end
end
