# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ValidationsService, type: :service do
  let(:service) { described_class.new }

  context 'when instance has no erros' do
    it 'does not throw error' do
      expect { service.validate(build(:exchange_request), 'error test') }.not_to raise_error
    end
  end

  context 'when instance has some error' do
    it 'throw a error' do
      exchange_request = build(:exchange_request, target: nil)
      expect { service.validate(exchange_request, 'error test') }.to raise_error(ModelConstraintError)
    end
  end
end
