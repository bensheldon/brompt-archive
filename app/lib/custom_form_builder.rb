# frozen_string_literal: true

class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def errors(method)
    object.errors.full_messages_for(method).map { |m| help_block(m) }.join.html_safe # rubocop:disable Rails/OutputSafety
  end

  def group(method, options = {}, &)
    class_names = if object.errors.key?(method)
                    "form-group has-error"
                  else
                    "form-group"
                  end

    content = @template.capture(&)
    @template.content_tag(:div, content, insert_class(class_names, options))
  end

  def label(method, text = nil, options = {}, &)
    super(method, text, insert_class("control-label", options), &)
  end

  %w(
    text_field
    email_field
    password_field
  ).each do |selector|
    class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
      def #{selector}(method, options = {})                     # def text_field(method, options = {})
        super(method, insert_class("form-control", options))    #   super(method, insert_class("form-control", options))
      end                                                       # end
    RUBY_EVAL
  end

  def select(method, values, options = {}, htm_options = {})
    super(method, values, options, insert_class("form-control", htm_options))
  end

  def help_block(message, options = {})
    @template.content_tag(:span, message.html_safe, insert_class("help-block", options)) # rubocop:disable Rails/OutputSafety
  end

  private

  def insert_class(class_name, options)
    output = options.dup
    output[:class] = ((output[:class] || "") + " #{class_name}").strip
    output
  end
end
