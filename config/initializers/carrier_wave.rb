fog_dir = Rails.env == 'production' ? 'bckt.full.of.sand' : 'dev-bckt.full.of.crap'

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAJCGKRFX6BRQKNL5Q',
    :aws_secret_access_key  => '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',             
    :region                 => 'eu-west-1',
    :path_style            => true
  }
  config.fog_directory  = fog_dir
  config.fog_public     = false
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
end