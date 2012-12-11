# coding: utf-8
module CarrierWave
  module TFS
    module Configuration
      extend ActiveSupport::Concern
      included do
        # TFS 服务器地址 / WebService 地址，如: 127.0.0.1:6666 或 http://api.tbcdn.com/tfs
        add_config :tfs_ns_addr
        # WebService 连接需要的 AppKey, 如果是用 tbfstool 来上传就不需要配置这个
        add_config :tfs_web_service_app_key
        # TFS bin 文件路径
        add_config :tfs_tool_path
        # 数组格式，用于多个域名循环使用
        add_config :tfs_cdn_domains
        # 二级目录
        add_config :tfs_bucket
        # 如果想在没有安装 TFS 的环境使用，请将这个设成 true，这样就会模拟 TFS 以文件方式存储
        add_config :tfs_not_installed

        #大文件url
        add_config :big_file_url
      end
    end

    module ClassMethods
      def add_config(name)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def self.#{name}(value=nil)
            @#{name} = value if value
            return @#{name} if self.object_id == #{self.object_id} || defined?(@#{name})
            name = superclass.#{name}
            return nil if name.nil? && !instance_variable_defined?("@#{name}")
            @#{name} = name && !name.is_a?(Module) && !name.is_a?(Symbol) && !name.is_a?(Numeric) && !name.is_a?(TrueClass) && !name.is_a?(FalseClass) ? name.dup : name
          end

          def self.#{name}=(value)
            @#{name} = value
          end

          def #{name}
            value = self.class.#{name}
            value.instance_of?(Proc) ? value.call : value
          end
        RUBY
      end
    end
  end
end
