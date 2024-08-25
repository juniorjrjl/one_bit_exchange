# frozen_string_literal: true

# Service to check class who use ActiveModel and check if instance have some constraint violation
class ValidationsService
  def validate(model, error_message)
    model.valid?
    return unless model.errors.any?

    errors = model.errors.errors.map do |e|
      translation_key = "#{model.class.name.to_snake_case}.#{e.attribute}.#{e.type}"
      message = build_message(translation_key, e.options)
      [message, e.attribute]
    end
    raise ModelConstraintError.new(error_message, errors)
  end

  private

  def build_message(key, params)
    return I18n.t(key, params) if I18n.exists?(key, params)

    I18n.t(key)
  end
end
