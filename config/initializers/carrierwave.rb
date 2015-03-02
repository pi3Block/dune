CarrierWave.configure do |config|
  if Rails.env.production? and Configuration[:aws_access_key]
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Configuration[:aws_access_key],
      aws_secret_access_key: Configuration[:aws_secret_key],
      region: Configuration[:aws_region]
    }
    config.fog_directory  = Configuration[:aws_bucket]
    config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }  # optional, defaults to { }
    config.asset_host = Configuration[:asset_host]
    #config.fog_region = Configuration[:aws_region]
  else
    config.enable_processing = false if Rails.env.test? or Rails.env.cucumber?
  end
end

module CarrierWave
  module RMagick

    def quality(percentage)
      manipulate! do |img|
        img.write(current_path){ self.quality = percentage } unless img.quality == percentage
        img = yield(img) if block_given?
        img
      end
    end

  end
end
