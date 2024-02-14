# frozen_string_literal: true

class ScreenshotsController < ApplicationController
  before_action -> { @meta_title = 'Screenshots' }

  def index
    images_dir = Rails.root.join("app/assets/images/")
    files = Rails.root.glob("app/assets/images/dev_screenshots/**/*.png")
    @groups = files.map { |file| file.to_s.sub images_dir.to_s, "" }
                   .group_by { |file| file.split('/')[1] }
  end
end
