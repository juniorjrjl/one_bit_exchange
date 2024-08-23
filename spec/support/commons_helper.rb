# frozen_string_literal: true

module Commons
  module ModelHelpers
    def expect_field_by_field_list(actual, expect, fields)
      actual.zip(expect).each do |a, e|
        expect_field_by_field(a, e, fields)
      end
    end

    def expect_field_by_field(actual, expect, fields)
      fields.each { |f| expect(actual.send(f)).to eq(expect.send(f)) }
    end

    def expect_props_is_nil(actual, fields)
      fields.each { |f| expect(actual[f]).to be_nil }
    end

    def expect_props_is_not_nil(actual, fields)
      fields.each { |f| expect(actual[f]).not_to be_nil }
    end

    def expect_array_sort_by(actual, field, reverse: false)
      expected = reverse ? actual.sort_by { |a| a[field] }.reverse : actual.sort_by { |a| a[field] }
      expect(actual).to eq(expected)
    end
  end
end
