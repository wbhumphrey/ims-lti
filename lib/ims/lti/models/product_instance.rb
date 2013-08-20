module IMS::LTI
  module Models
    class ProductInstance
      attr_accessor :guid
      attr_accessor :product_info
      attr_accessor :support
      attr_accessor :service_provider

      def valid?
        !!(guid && product_info && product_info.valid?)
      end

      def to_params
        {
            'guid' => guid,
            'product_info' => (product_info ? product_info.to_params : nil),
            'support' => (support ? {'email' => support} : nil),
            'service_provider' => (service_provider ? service_provider.to_params : nil),
        }.delete_if {|k,v| !v}
      end
    end
  end
end
