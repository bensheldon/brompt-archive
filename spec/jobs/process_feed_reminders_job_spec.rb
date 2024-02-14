# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessFeedRemindersJob do
  describe '#perform' do
    it 'does not blow up' do
      expect { described_class.new.perform }.not_to raise_error
    end
  end
end
