module CarrierWave
  module TFS
    module DelegateAttrs
      extend ::ActiveSupport::Concern
    
      module ClassMethods
        def store_file_name_delegate_attr(attribute, default = nil)

          var_name = :"@#{attribute}"

          define_method :"#{attribute}=" do |value|
            model_accessor = store_file_name_getter_name(attribute)     
            puts "--- #{self.model.send(:id)}"    
            self.model.send(:"#{model_accessor}=", value) 
          end
        end
      end
    
      private
      def store_file_name_getter_name(attribute)
        name = []
        name << mounted_as if mounted_as.present?
        name << version_name if version_name.present?
        name << attribute
        name.join('_')
      end
    end
  end
end
