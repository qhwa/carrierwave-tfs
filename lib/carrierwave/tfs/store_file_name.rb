module CarrierWave
  module TFS
    module StoreFileName
      extend ActiveSupport::Concern

      included do
        include CarrierWave::TFS::DelegateAttrs

        store_file_name_delegate_attr :file_name, ''
      end
    end
  end
end