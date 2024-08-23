# frozen_string_literal: true

Rails.application.routes.draw do
  defaults format: :json do
    get 'up' => 'rails/health#show', as: :rails_health_check
    get 'exchanges/convert', to: 'exchanges#convert'
    get 'exchanges/available', to: 'exchanges#available'
  end
end
