module IMS::LTI
  module Models
    class RestService
      attr_accessor :id
      attr_accessor :endpoint
      attr_accessor :formats
      attr_accessor :actions

      def add_format(format)
        @formats ||= []
        @formats << format
      end

      def add_action(action)
        @actions ||= []
        @actions << action
      end

      def valid?
        !!(id && endpoint)
      end

      def to_params
        {
            '@id' => id,
            'endpoint' => endpoint,
            'format' => formats,
            'action' => actions
        }.delete_if {|k,v| !v}
      end
    end
  end
end
