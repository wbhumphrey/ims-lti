module IMS::LTI
  module Models
    class ServiceProvider
      attr_accessor :id
      attr_accessor :guid
      attr_accessor :timestamp
      attr_accessor :provider_name
      attr_accessor :description
      attr_accessor :support

      def valid?
        !!(guid && timestamp && provider_name)
      end

      def to_params
        params = {
            '@id' => id,
            'guid' => guid,
            'timestamp' => timestamp,
            'provider_name' =>
                {'key' => 'service_provider.name', 'default_value' => provider_name},
            'description' =>
                (description ? {'key' => 'service_provider.description', 'default_value' => description} : nil),
            'support' => support,
        }.delete_if {|k,v| !v}
      end
    end
  end
end
