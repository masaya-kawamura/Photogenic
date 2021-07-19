require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Photogenic
  class Application < Rails::Application

    config.load_defaults 5.2
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml')]
    config.time_zone = 'Tokyo'

    Rails.application.configure do
      config.imgix = {
        source: ENV['IMGIX_SOURCE'],
        use_https: true,
        include_library_param: true
      }
    end

    # generateコマンド実行時のrspecファイル作成に関する設定
    config.generators do |g|
      g.test_framework :rspec,
      # cintriller_specs: false,
      # fixtures: false,
      view_specs: false,
      helper_specs: false,
      routing_specs: false
    end
  end

end
