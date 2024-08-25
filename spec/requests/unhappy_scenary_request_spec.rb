# frozen_string_literal: true

require 'rails_helper'
require 'net/http'
require 'json'

RSpec.describe 'Exchanges', type: :request do
  describe 'unhappy scenary' do
    before do
      available_res = { 'currencySymbols' => { 'USD' => 'dollar', 'JPY' => 'yenni', 'BRL' => 'real' } }.to_json
      allow(Net::HTTP).to receive(:get).with(URI('http://fakecurrency.com/currency-symbols')).and_return(available_res)
    end

    after do
      Redis.new(url: ENV['REDIS_URL']).del('symbols')
    end

    context 'invalid params' do
      [
        { target: '   ', source: 'USD', amount: 1.00 },
        { target: 'AAA', source: 'USD', amount: 1.00 },
        { target: 'USD', source: '   ', amount: 1.00 },
        { target: 'USD', source: 'AAA', amount: 1.00 },
        { target: 'BRL', source: 'JPY', amount: nil },
        { target: 'JPY', source: 'BRL', amount: '1a' }
      ].each do |params|
        it "request using follow params #{params}" do
          get "/exchanges/convert?source=#{params[:target]}&target=#{params[:source]}&amount=#{params[:amount]}"
          expect_status_is_bad_request
        end
      end
    end
  end
end
