# frozen_string_literal: true

module ApplicationHelper
  ROOT_PAGE_TITLE = 'Brompt - schedule reminders for blogs and marketing'
  MissingPageTitleError = Class.new(StandardError)

  def form_errors_for(model)
    return unless model.errors.any?

    content_tag(:div, class: 'panel panel-danger') do
      concat content_tag(:div, "#{pluralize(model.errors.count, 'error')} in this form:", class: 'panel-heading')
      concat content_tag(:ul, class: 'list-group') {
        model.errors.full_messages.each do |msg|
          concat content_tag(:li, msg, class: 'list-group-item')
        end
      }
    end
  end

  def formatted_page_title
    return ROOT_PAGE_TITLE if request.path == root_path

    title_fragment = if @meta_title # rubocop:disable Rails/HelperInstanceVariable
                       @meta_title # rubocop:disable Rails/HelperInstanceVariable
                     elsif content_for?(:meta_title)
                       content_for(:meta_title)
                     end

    if title_fragment.present?
      "#{strip_tags(title_fragment)} | Brompt".html_safe # rubocop:disable Rails/OutputSafety
    elsif Rails.env.development? || Rails.env.test?
      raise MissingPageTitleError, "#{request.controller_class} - supply a page title with `@meta_title = 'My Title'` or `provide :meta_title, 'My Title'"
    else
      ROOT_PAGE_TITLE
    end
  end
end
