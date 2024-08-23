# frozen_string_literal: true

json.ignore_nil!
json.ignore_nil!
json.member_of.presence
json.status @problem.status
json.message @problem.message
if @problem.field_errors
  json.field_errors(@problem.field_errors) do |field_error|
    json.field field_error.field.to_s
    json.error_message field_error.error_message
  end
end
