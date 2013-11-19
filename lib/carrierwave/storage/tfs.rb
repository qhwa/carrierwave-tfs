# encoding: utf-8
require 'rtfs'
require 'carrierwave'
module CarrierWave
  module Storage

    ##
    # The GridFS store uses MongoDB's GridStore file storage system to store files
    #
    # There are two ways of configuring the GridFS connection. Either you create a
    # connection or you reuse an existing connection.
    #
    # Creating a connection looks something like this:
    #
    #     CarrierWave.configure do |config|
    #       config.storage = :tfs
    #       config.tfs_host = "your-host.com"
    #       config.tfs_port = "27017"
    #       config.tfs_tool_path = "/usr/bin/tfstool" # default is /home/admin/tfs/bin/tfstool
    #       config.tfs_cdn_domains = ["http://img01.tfscdn.com","http://img02.tfscdn.com"]
    #     end
    #
    #
    class TFS < Abstract

      class File

        attr_reader :uploader

        def initialize(uploader, path)
          @uploader, @path = uploader, path
        end

        def path
          version = "_#{uploader.version_name}" if !uploader.version_name.blank?
          field_name = "#{uploader.mounted_as}#{version}_file_name"
          if uploader.model.respond_to?(field_name)
            uploader.model.send(field_name)
          else
            nil
          end
        end

        def url
          if self.path.nil? && uploader.respond_to?('default_url')
            uploader.default_url
          elsif uploader.tfs_cdn_domains
            domain = uploader.tfs_cdn_domains[rand(uploader.tfs_cdn_domains.count)]
            if(self.path.split("/").last.index("L") == 0)
              #大文件
              ["http://",uploader.big_file_url,"/L0/",self.path.split("/").last].join("")
            else
              ["http://",[domain, self.path].join('/').squeeze("/")].join("")
            end
          else
            nil
          end
        end

        def read
          tfs.get(self.path)
        end

        def write(file)
          ext = uploader.store_path.split(".").last
          filename = tfs.put(file.path, :ext => ".#{ext}")

          @path = [uploader.tfs_bucket,[filename,ext].join(".")].join("/")

          if(filename.index("L") == 0 && uploader.big_file_url)
            #大文件
            @path = ["L0",[filename,ext].join(".")].join("/")
          end
          uploader.file_name = @path
          @path
        end

        def delete
          tfs.rm( file_id ) if path
        end

        # 根据路径获取TFS的文件id
        def file_id
          # path格式: [bucket]/[tfs_file_id].[文件格式]
          # 例如      "tfscom/Txadftegx234x.jpg"
          # 我们需要的是中间的部分 (Txadftegx234x)
          ::File.basename(path).sub /\.\w+$/, ''
        end

        def content_type
          nil
        end

        def file_length
          self.read.length
        end
        alias :size :file_length

      protected

        def tfs
          @tfs ||= RTFS::Client.tfs(:ns_addr => uploader.tfs_ns_addr,
                                    :appkey => uploader.tfs_web_service_app_key,
                                    :tfstool_path => uploader.tfs_tool_path)
        end

      end

      ##
      # Store the file in TFS
      #
      # === Parameters
      #
      # [file (CarrierWave::SanitizedFile)] the file to store
      #
      # === Returns
      #
      # [CarrierWave::SanitizedFile] a sanitized file
      #
      def store!(file)
        stored = CarrierWave::Storage::TFS::File.new(uploader, uploader.store_path)
        stored.write(file)
        stored
      end

      ##
      # Retrieve the file from TFS
      #
      # === Parameters
      #
      # [identifier (String)] the filename of the file
      #
      # === Returns
      #
      # [CarrierWave::Storage::GridFS::File] a sanitized file
      #
      def retrieve!(identifier)
        CarrierWave::Storage::TFS::File.new(uploader, uploader.store_path(identifier))
      end

    end # File
  end # Storage
end # CarrierWave
