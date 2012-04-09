# CarrierWave for TFS

This gem adds support for Taobao [TFS](http://code.taobao.org/project/view/366/) to [CarrierWave](https://github.com/jnicklas/carrierwave/)

## Installation

    gem install carrierwave-tfs

## Using Bundler

    gem 'rtfs'
    gem 'carrierwave-tfs'

## Configuration

创建 `config/initializes/carrierwave.rb`

    CarrierWave.configure do |config|
      config.storage = :tfs
      # 如果想在没有安装 TFS 的环境使用，请将这个设成 true，这样就会模拟 TFS 以文件方式存储
      config.tfs_not_installed = false
      ＃ 服务器，如果 tfs_not_installed 的话，请设置成一个目录地址
      config.tfs_host = "your-host.com"
      # 服务器端口
      config.tfs_port = "27017"
      # 二级目录
      config.tfs_bucket = "tfscom"
      # TFS bin 文件地址, 默认 /home/admin/tfs/bin/tfstool
      config.tfs_tool_path = "/usr/bin/tfstool"
      # 域名
      config.tfs_cdn_domains = ["img01.tfscdn.com","img02.tfscdn.com"]
    end


上面的配置返回的地址格式将会是这样: `http://img01.tfscdn.com/tfscom/d5b5c2c676e59eb005436cd50eecce8dd4635066.jpg`


## 关于 Model 里面

    class AvatarUploader < CarrierWave::Uploader::Base
      include CarrierWave::MiniMagick

      version :normal do
        process :resize_to_fill => [48, 48]
      end
  
      version :small do
        process :resize_to_fill => [16, 15]
      end
    end

    class User
      include Mongoid::Document
  
      # 需要单独定义几个字段用来存放文件地址，字段个数与 Uploader 的 version 对应,因为 TFS 每个文件名是不同的
      field :avatar_file_name
      field :avatar_normal_file_name
      field :avatar_small_file_name
  
      mount_uploader :avatar, AvatarUploader
    end