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
        
        def initialize(uploader, path)
          @path = path
          @uploader = uploader
        end

        def path
          names = @path.split("/").last.split("_")
          version = names.length == 1 ? "" : names.first
          version = "_#{version}" if !version.blank?
          field_name = "#{@uploader.mounted_as}#{version}_file_name"
          if @uploader.model.respond_to?(field_name)
            @uploader.model.send(field_name)
          else
            nil
          end 
        end

        def url
          if @uploader.tfs_cdn_domains
            domain = @uploader.tfs_cdn_domains[rand(@uploader.tfs_cdn_domains.count)]
            ["http://",[domain, self.path].join('/').squeeze("/")].join("")
          else
            nil
          end
        end

        def read
          tfs.get(self.path)
        end

        def write(file)
          ext = file.path.split(".").last
					filename = tfs.put(file.path, :ext => ".#{ext}")
					@path = [@uploader.tfs_bucket,[filename,ext].join(".")].join("/")
          @uploader.file_name = @path
					@path
        end

        def delete
          # tfs.rm(@path)
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
          if @uploader.tfs_not_installed
            $tfs ||= FakeTfs::Client.new(:ns_addr => @uploader.tfs_host)
          else
            @tfs ||= RTFS::Client.new(:ns_addr => [@uploader.tfs_host,@uploader.tfs_port].join(":"),
                                    :tfstool_path => @uploader.tfs_tool_path)
          end
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
