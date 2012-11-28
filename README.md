# CarrierWave for TFS

This gem adds support for Taobao [TFS](http://code.taobao.org/project/view/366/) to [CarrierWave](https://github.com/jnicklas/carrierwave/)

## Installation

```bash
$ gem install carrierwave-tfs
```

## Using Bundler

```ruby
gem 'rtfs'
gem 'carrierwave-tfs'
```

## Configuration

创建 `config/initializes/carrierwave.rb`


```ruby
CarrierWave.configure do |config|
  config.storage = :tfs

  # == Begin 下面有两种配置方式，（TFS 客户端 或 WebService)
      
  # 客户端
  config.tfs_ns_addr = "127.0.0.1:27017"
  config.tfs_tool_path = "/usr/bin/tfstool"

  # WebService
  config.tfs_ns_addr = "http://127.0.0.1:3900"
  config.tfs_web_service_app_key = "Kshj*&2kj1"

  # 二级目录
  config.tfs_bucket = "tfscom"
  # TFS bin 文件地址, 默认 /home/admin/tfs/bin/tfstool
      
  # 域名
  config.tfs_cdn_domains = ["img01.tfscdn.com","img02.tfscdn.com"]
end
```


上面的配置返回的地址格式将会是这样: `http://img01.tfscdn.com/tfscom/d5b5c2c676e59eb005436cd50eecce8dd4635066.jpg`


## 关于 Model 里面

```ruby
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
```