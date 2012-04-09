module CarrierWave
  module TFS
    module StoreFileName
      extend ActiveSupport::Concern

      included do
        include CarrierWave::TFS::DelegateAttrs

        store_file_name_delegate_attr :file_name, ''
        after :store, :save_model
      end
      
      def save_model(a)
        self.model.save
      end
    end
  end
end