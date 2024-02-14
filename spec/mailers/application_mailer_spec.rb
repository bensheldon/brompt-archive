# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationMailer, type: :mailer do
  describe '#simple' do
    let!(:user) { create(:user) }

    it 'sends an email' do
      mail = described_class.simple(
        to: user.email,
        subject: "Hello",
        body: "Something\nElse"
      ).deliver_now

      expect(mail).to have_attributes(
        to: [user.email],
        subject: 'Hello'
      )
      expect(mail.body.encoded).to include("Something\r\nElse")
    end
  end
end
