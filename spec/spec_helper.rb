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
  config.tfs_host = [Rails.root,"uploads"].join("/")
  # config.tfs_port = "3100"
  config.tfs_tool_path = ""
  config.tfs_bucket = "tfscom"
  config.tfs_cdn_domains = %w(img03.taobaocdn.com img02.taobaocdn.com img01.taobaocdn.com img04.taobaocdn.com)
  config.tfs_not_installed = true
end

ActiveRecord::Migration.verbose = false
