# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrelaunchUser, type: :model do
  describe '#email' do
    it 'is required' do
      prelaunch_user = described_class.new email: nil

      expect(prelaunch_user).not_to be_valid
      expect(prelaunch_user.errors[:email]).to be_present
    end
  end
end
