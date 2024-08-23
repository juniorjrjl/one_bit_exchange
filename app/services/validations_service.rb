# frozen_string_literal: true

class ValidationsService
  def validate(model, error_message)
    model.valid?
    return unless model.errors.any?

    errors = model.errors.errors.map do |e|
      translation_key = "#{model.class.name.to_snake_case}.#{e.attribute}.#{e.type}"
      begin
        message = I18n.t(translation_key, e.options)
      rescue Exception
        message = I18n.t(translation_key)
      end
      [message, e.attribute]
    end
    raise ModelConstraintError.new(error_message, errors)
  end
end
