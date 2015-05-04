Dune::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  Rails.application.routes.default_url_options[:host] = 'www.dune-investissement-solidaire.fr'

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like nginx, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_assets = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Set to :debug to see everything in the log.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]
  config.assets.precompile << ['normalize.css', 'animate.css', 'backgroundsize.htc']
  config.assets.initialize_on_precompile = false

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # https://github.com/ryanb/cancan/issues/511
  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger.const_get((ENV["LOG_LEVEL"] || "ERROR").upcase)


  # Use a different cache store in production.
  if Configuration[:memcachedcloud_servers]
    config.cache_store = :dalli_store,
      Configuration[:memcachedcloud_servers].split(','),
      {
        username: Configuration[:memcachedcloud_username],
        password: Configuration[:memcachedcloud_password]
      }
  end

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  config.action_controller.asset_host = Configuration[:asset_host]

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
  # config.assets.precompile += %w( search.js )

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found).
  #I18n.default_locale = :fr
  #config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Disable automatic flushing of the log to improve performance.
  config.autoflush_log = true

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  config.action_dispatch.default_headers = {
    'X-Frame-Options' => 'ALLOWALL'
  }

  config.action_mailer.smtp_settings = {
      :address   => "smtp.mandrillapp.com",
      :port      => 587, # ports 587 and 2525 are also supported with STARTTLS
      :enable_starttls_auto => true, # detects and uses STARTTLS
      :user_name => Configuration[:MANDRILL_USERNAME],
      :password  => Configuration[:MANDRILL_APIKEY], # SMTP password is any valid API key
      :authentication => 'plain', # Mandrill supports 'plain' or 'login'
      :domain => 'www.dune-investissement-solidaire.fr', # your domain to identify your server when connecting
    }
end
