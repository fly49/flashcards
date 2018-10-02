require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  
  if Rails.env.development? || Rails.env.test?
    config.storage = :file
  end
  
  if Rails.env.production?
    config.storage = :fog
  end
  
  config.fog_provider = 'fog/aws'                        
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region:                 'eu-central-1'
  }
  config.fog_directory  = 'flymypiecardimagebucket'
end
