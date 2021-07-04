require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Photogenic
  class Application < Rails::Application

    config.load_defaults 5.2

    Rails.application.configure do
      config.imgix = {
        source: ENV['IMGIX_SOURCE'],
        use_https: true,
        include_library_param: true
      }
    end

  end
end
