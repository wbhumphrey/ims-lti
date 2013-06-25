module IMS::LTI
  # Mixin module for managing LTI Launch Data
  #
  # Launch data documentation:
  # http://www.imsglobal.org/lti/v1p1pd/ltiIMGv1p1pd.html#_Toc309649684
  module Messages
    module Base
      module ClassMethods
        def register_parameters(parameters, required=false)
          parameters.each {|param| register_parameter(param, required)}
        end

        def register_parameter(parameter, required=false)
          self.class_variable_get(:@@required_parameters).add? parameter.to_s if required

          if self.class_variable_get(:@@accepted_parameters).add?(parameter.to_s)
            attr_reader parameter if !method_defined?(parameter)
            attr_writer parameter if !method_defined?("#{parameter}=")
          end
        end
      end

      def self.included(mod)
        mod.extend(ClassMethods)
        mod.class_variable_set(:@@accepted_parameters, Set.new)
        mod.class_variable_set(:@@required_parameters, Set.new)

        mod.register_parameters %w{lti_message_type lti_version}, required=true
        mod.register_parameters %w{
          user_id
          roles
          launch_presentation_locale
          launch_presentation_document_target
          launch_presentation_css_url
          launch_presentation_width
          launch_presentation_height
        }
      end

      # Hash of custom parameters, the keys will be prepended with "custom_" at launch
      attr_writer :custom_params
      def custom_params
        @custom_params ||= {}
      end

      # Hash of extension parameters, the keys will be prepended with "ext_" at launch
      attr_writer :ext_params
      def ext_params
        @ext_params ||= {}
      end

      # Hash of parameters to add to the launch. These keys will not be prepended
      # with any value at launch
      attr_writer :non_spec_params
      def non_spec_params
        @non_spec_params ||= {}
      end

      def lti_version
        @lti_version ||= 'LTI-2p0'
      end

      def set_custom_param(key, val)
        custom_params[key] = val
      end

      def get_custom_param(key)
        custom_params[key]
      end

      def set_non_spec_param(key, val)
        non_spec_params[key] = val
      end

      def get_non_spec_param(key)
        non_spec_params[key]
      end

      def set_ext_param(key, val)
        ext_params[key] = val
      end

      def get_ext_param(key)
        ext_params[key]
      end

      def generate_launch_data
        missing_fields = validate()
        unless missing_fields.empty?
          raise IMS::LTI::InvalidLTIConfigError,
                "Missing required params (#{missing_fields.join(', ')})"
        end
        to_params
      end

      # Create a new Hash with all launch data. Custom/Extension keys will have the
      # appropriate value prepended to the keys and the roles are set as a comma
      # separated String
      def to_params
        launch_data_hash.merge(add_key_prefix(custom_params, 'custom')).merge(add_key_prefix(ext_params, 'ext')).merge(non_spec_params)
      end

      # Populates the launch data from a Hash
      #
      # Only keys in @@accepted_parameters and
      # and those that start with 'custom_' or 'ext_'
      # will be pulled from the provided Hash
      def process_params(params)
        params.each_pair do |key, val|
          if accepted_parameters.member?(key)
            self.send("#{key}=", val)
          elsif key =~ /custom_(.*)/
            custom_params[$1] = val
          elsif key =~ /ext_(.*)/
            ext_params[$1] = val
          end
        end
      end

      def accepted_parameters
        self.class.class_variable_get(:@@accepted_parameters).to_a
      end

      def required_parameters
        self.class.class_variable_get(:@@required_parameters).to_a
      end

      #returns a list of parameters that are required but not included
      def validate
        required_parameters.select{|param| !self.send(param)}
      end

      def valid?
        required_parameters.all?{|param| self.send(param)}
      end

      private
      def launch_data_hash
        accepted_parameters.inject({}) { |h, k| h[k] = self.send(k) if self.send(k); h }
      end

      def add_key_prefix(hash, prefix)
        hash.keys.inject({}) { |h, k| h["#{prefix}_#{k}"] = hash[k]; h }
      end
    end
  end
end

require 'ims/lti/messages/basic_lti_launch_request'
require 'ims/lti/messages/tool_proxy_registration_request'
require 'ims/lti/messages/tool_proxy_reregistration_request'
