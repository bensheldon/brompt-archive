# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # https://stackoverflow.com/questions/4804591/rails-activerecord-validate-single-attribute
  def valid_attributes?(*attributes)
    attributes.each do |attribute|
      self.class.validators_on(attribute).each do |validator|
        validator.validate_each(self, attribute, send(attribute))
      end
    end

    errors.to_h.slice(*attributes).none? # rubocop:disable Rails/DeprecatedActiveModelErrorsMethods
  end
end
