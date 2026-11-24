ENV['RAILS_ENV'] = 'test'

require 'rspec/core'
require 'airborne' if ENV.fetch('AIRBORNE_LOAD_ORDER', 'before') == 'before'
require 'rails'
require 'action_controller/railtie'

module AirborneRailsIntegration
  class Application < Rails::Application
    config.root = File.expand_path('../../tmp/rails-app', __dir__)
    config.eager_load = false
    config.secret_key_base = 'airborne-rails-integration-test-secret'
    config.hosts.clear
    config.logger = Logger.new(File::NULL)
  end

  class UsersController < ActionController::API
    def show
      render json: { error: { message: 'not found', id: params[:id] } }, status: :not_found
    end

    def create
      render json: { name: params[:name] }, status: :created
    end
  end
end

AirborneRailsIntegration::Application.initialize!
AirborneRailsIntegration::Application.routes.draw do
  get '/api/users/:id', to: 'airborne_rails_integration/users#show'
  post '/api/users', to: 'airborne_rails_integration/users#create'
end

require 'rspec/rails'
require 'airborne' unless ENV.fetch('AIRBORNE_LOAD_ORDER', 'before') == 'before'
