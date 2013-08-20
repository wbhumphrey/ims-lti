module IMS::LTI
  module Models
    class ProductFamily
      attr_accessor :code
      attr_accessor :vendor

      def valid?
        !!(code && vendor && vendor.valid?)
      end

      def to_params
        {
            'code' => code,
            'vendor' => (vendor ? vendor.to_params : nil)
        }.delete_if {|k,v| !v}
      end
    end
  end
end
