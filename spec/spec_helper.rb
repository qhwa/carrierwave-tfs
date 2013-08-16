require 'rubygems'
require 'rspec'
require 'rspec/autorun'
require 'rails'
require 'active_record'
require "carrierwave"
require 'carrierwave/orm/activerecord'
require 'carrierwave/processing/mini_magick'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require "carrierwave-tfs"


module Rails
  class <<self
    def root
      [File.expand_path(__FILE__).split('/')[0..-3].join('/'),"spec"].join("/")
    end
  end
end

CarrierWave.configure do |config|
  config.storage = :tfs
  config.tfs_ns_addr = "http://restful-store.daily.tbsite.net:3800"
  config.tfs_web_service_app_key = "4f8fbb734d4d8"
  config.tfs_bucket = "tfscom"
  config.tfs_cdn_domains = %w(10.232.4.42)
  config.tfs_not_installed = true
end

ActiveRecord::Migration.verbose = false
