# frozen_string_literal: true

require "rails_helper"

RSpec.describe 'Legacy paths', type: :request do
  specify do
    get('/blog')
    expect(response).to redirect_to(root_path)

    get('/blog/something')
    expect(response).to redirect_to(root_path)

    get('/signup')
    expect(response).to redirect_to(root_path)

    get('/stats')
    expect(response).to redirect_to(root_path)
  end
end
