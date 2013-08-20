module IMS::LTI
  module Models
    class ToolConsumerProfile
      attr_writer :context
      def context
        @context || 'http://www.imsglobal.org/imspurl/lti/v2/ctx/ToolConsumerProfile'
      end

      attr_writer :type
      def type
        @type || 'ToolConsumerProfile'
      end

      attr_accessor :id

      attr_writer :lti_version
      def lti_version
        @lti_version || 'LTI-2p0'
      end

      attr_accessor :guid
      attr_accessor :product_instance
      attr_accessor :capabilities_offered
      attr_accessor :services_offered

      def add_capability_offered(capability_offered)
        @capabilities_offered ||= []
        @capabilities_offered << capability_offered
      end

      def add_service_offered(service_offered)
        @services_offered ||= []
        @services_offered << service_offered
      end

      def valid?
        is_valid = !!(context && type && guid &&
            product_instance && product_instance.is_valid?)

        is_valid &= capabilities_offered.all?{|c| c.valid?} if capabilities_offered
        is_valid &= services_offered.all?{|s| s.valid?} if services_offered

        is_valid
      end

      def to_params
        {
          '@context' => context,
          '@type' => type,
          '@id' => id,
          'lti_version' => lti_version,
          'guid' => guid,
          'product_instance' => (product_instance ? product_instance.to_params : nil),
          'capability_offered' =>
            (capabilities_offered ? capabilities_offered.map {|c| c.to_params } : nil),
          'services_offered' =>
            (services_offered ? services_offered.map{|s| s.to_params} : nil),
        }.delete_if {|k,v| !v}
      end
    end
  end
end