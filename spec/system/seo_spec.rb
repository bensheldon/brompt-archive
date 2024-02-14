# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SEO", type: :system do
  it 'has appropriate homepage meta tags' do
    visit root_path

    meta_description = find('meta[name="description"]', visible: false)['value']
    expect(meta_description.size).to be < 155
  end
end
