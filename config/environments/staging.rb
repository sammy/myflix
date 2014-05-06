Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.domain = 'hidden-scrubland-5956.herokuapp.com'


  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.mailgun.org',
    port:                 587,
    domain:               'sandbox23de00cba2ee4381ad9feb651eb4f544.mailgun.org',
    user_name:            ENV['MAILGUN_USERNAME'],
    password:             ENV['MAILGUN_PASSWORD'],
    authentication:       'plain',
    enable_starttls_auto: true 
  }
end