module IMS::LTI
  module Models
    class ProductInfo
      attr_accessor :product_name #value? key?
      attr_accessor :product_version
      attr_accessor :description
      attr_accessor :technical_description
      attr_accessor :product_family

      def valid?
        !!(product_name && product_version &&
            product_family && product_family.valid?)
      end

      def to_params
        {
            'product_name' =>
                {'key' => 'product.name', 'default_value' => product_name},
            'product_version' => product_version,
            'description' => description,
            'technical_description' => technical_description,
            'product_family' => (product_family ? product_family.to_params : nil)
        }.delete_if {|k,v| !v}
      end
    end
  end
end
