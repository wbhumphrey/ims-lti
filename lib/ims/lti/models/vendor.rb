module IMS::LTI
  module Models
    class Vendor
      attr_accessor :id
      attr_accessor :code
      attr_accessor :name
      attr_accessor :description
      attr_accessor :website
      attr_accessor :timestamp
      attr_accessor :contact

      def valid?
        !!(code && timestamp)
      end

      def to_params
        {
            '@id' => id,
            'code' => code,
            'name' => name,
            'description' => description,
            'website' => website,
            'timestamp' => timestamp,
            'contact' => contact
        }.delete_if {|k,v| !v}
      end
    end
  end
end
