CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAJCGKRFX6BRQKNL5Q',                        # required
    :aws_secret_access_key  => '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',                        # required
    :region                 => 'eu-west-1',                  # optional, defaults to 'us-east-1'
    # :endpoint               => 'http://bckt.full.of.sand.s3.amazonaws.com', # optional, defaults to nil
    # :host                   => 's3.amazonaws.com'
    :path_style            => true
  }
  config.fog_directory  = 'bckt.full.of.sand'                     # required
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end