require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DemographicsDataExchange
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    #autoloads lib folder during production
    config.eager_load_paths << Rails.root.join("lib")

    #autoloads lib folder during development
    config.autoload_paths << Rails.root.join("lib")

    #ActiveJob adapter
    config.active_job.queue_adapter = ActiveJob::QueueAdapters::AsyncAdapter.new(min_threads:1, 
      max_threads: 1)

    #Action Cable
    config.action_cable.mount_path = '/cable'
    config.action_cable.disable_request_forgery_protection = true

    
    config.time_zone = 'Harare'
    config.active_record.default_timezone = :local
  end
end
