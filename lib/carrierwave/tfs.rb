require "carrierwave/storage/tfs"
require "carrierwave/tfs/store_file_name"
require "carrierwave/tfs/delegate_attrs"
require "carrierwave/tfs/configuration"
CarrierWave.configure do |config|
  config.storage_engines.merge!({:tfs => "CarrierWave::Storage::TFS"})
end

CarrierWave::Uploader::Base.send(:include,CarrierWave::TFS::Configuration)
CarrierWave::Uploader::Base.send(:include,CarrierWave::TFS::StoreFileName)