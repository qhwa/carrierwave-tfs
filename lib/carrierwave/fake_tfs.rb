# -*- encoding : utf-8 -*-
module CarrierWave
  module FakeTfs
    class Client
      def initialize(options = {})
        @ns_addr = options[:ns_addr] || "uploads/tfs/"
        if @ns_addr[0] != "/"
          @ns_addr = [Rails.root,"public",@ns_addr].join("/")
        end
      end
    
      def put(file_path, options = {})
        ext = options[:ext] || File.extname(file_path)
        ext = ".jpg" if ext.blank?
        file_name = ["T1_",Digest::SHA1.hexdigest(file_path),ext].join("")

        new_path = [@ns_addr,file_name].join("/")

        FileUtils.cp(file_path, new_path)
        File.basename(new_path.gsub(ext,""))
      end
    
      def rm_file(file_id)
        puts "FakeTFS: removing #{file_id}\n"
        Dir.glob(File.join(@ns_addr, "#{file_id}.*"))[0]
      end
    end
  end
end