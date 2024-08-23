# frozen_string_literal: true

module Requests
  module JsonHelpers
    def body_to_struct
      JSON.parse(response.body).to_struct
    end

    def body_list_to_struct
      JSON.parse(response.body).map(&:to_struct)
    end

    def is_empty_body
      expect(response.body).to be_empty
    end

    def fix_types(struct, fields, values)
      fields.each_with_index { |f, i| struct[f] = values[i] }
      struct
    end
  end

  module StatusHelpers
    def expect_status_is_ok
      expect_status(:ok)
    end

    def expect_status_is_created
      expect_status(:created)
    end

    def expect_status_is_bad_request
      expect_status(:bad_request)
    end

    private

    def expect_status(expectation)
      expect(response).to have_http_status(expectation)
    end
  end
end
