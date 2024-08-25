# frozen_string_literal: true

require 'rails_helper'
require 'net/http'
require 'json'

RSpec.describe 'Exchanges', type: :request do
  context 'GET #available' do
    let(:symbols) { build_list(:available_dto, 5) }

    before do
      response = { 'currencySymbols' => symbols.each_with_object({}) { |d, m| m[d.symbol] = d.description } }.to_json
      allow(Net::HTTP).to receive(:get).with(URI('http://fakecurrency.com/currency-symbols')).and_return(response)
      get '/exchanges/available'
      get '/exchanges/available'
    end

    after do
      Redis.new(url: ENV['REDIS_URL']).del('symbols')
    end

    it 'then http status is ok' do
      expect_status_is_ok
    end

    it 'mock called one time' do
      expect(Net::HTTP).to have_received(:get).exactly(1).times
    end

    it 'response have available currencies' do
      symbols.each do |s|
        expect(response.body).to include(s.symbol)
        expect(response.body).to include(s.description)
      end
    end
  end
end
