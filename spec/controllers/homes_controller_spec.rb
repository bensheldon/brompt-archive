# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomesController, type: :controller do
  render_views

  describe '#index' do
    it 'renders' do
      get :index
      expect(response).to have_http_status :ok
    end
  end
end
