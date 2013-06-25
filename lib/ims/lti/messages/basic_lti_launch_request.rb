require 'securerandom'

module IMS::LTI
  module Messages
    class BasicLtiLaunchRequest
      include IMS::LTI::Messages::Base

      attr_accessor :launch_url
      attr_accessor :consumer_key
      attr_accessor :consumer_secret

      attr_writer :timestamp
      def timestamp
        @timestamp ||= Time.now.to_i
      end

      attr_writer :nonce
      def nonce
        @nonce ||= SecureRandom.uuid
      end

      register_parameter :resource_link_id, required=true
      register_parameters %w{
        context_id
        context_type
        launch_presentation_return_url
        role_scope_mentor
        tool_consumer_instance_guid
        user_image
      }

      #These parameters are deprecated in LTI 2.0
      register_parameters %w{
        context_title
        context_label
        resource_link_title
        resource_link_description
        lis_person_name_given
        lis_person_name_family
        lis_person_name_full
        lis_person_contact_email_primary
        lis_person_sourcedid
        lis_course_offering_sourcedid
        lis_course_section_sourcedid
        tool_consumer_info_product_family_code
        tool_consumer_info_product_family_version
        tool_consumer_instance_name
        tool_consumer_instance_description
        tool_consumer_instance_url
        tool_consumer_instance_contact_email
      }

      def lti_message_type
        'basic-lti-launch-request'
      end

      # Generate the launch data including the necessary OAuth information
      def generate_launch_data(options = {})
        params = super()

        raise IMS::LTI::InvalidLTIConfigError, "Missing launch url" unless launch_url
        raise IMS::LTI::InvalidLTIConfigError, "Missing consumer key" unless consumer_key
        raise IMS::LTI::InvalidLTIConfigError, "Missing consumer secret" unless consumer_secret

          uri = URI.parse(launch_url)

        if uri.port == uri.default_port
          host = uri.host
        else
          host = "#{uri.host}:#{uri.port}"
        end

        consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {
            :site => "#{uri.scheme}://#{host}",
            :signature_method => "HMAC-SHA1"
        })

        path = uri.path
        path = '/' if path.empty?
        if uri.query && uri.query != ''
          CGI.parse(uri.query).each do |query_key, query_values|
            unless params[query_key]
              params[query_key] = query_values.first
            end
          end
        end
        options = {
            :scheme => 'body',
            :timestamp => timestamp,
            :nonce => nonce
        }

        request = consumer.create_signed_request(:post, path, nil, options, params)

        # the request is made by a html form in the user's browser, so we
        # want to revert the escapage and return the hash of post parameters ready
        # for embedding in a html view
        hash = {}
        request.body.split(/&/).each do |param|
          key, val = param.split(/=/).map { |v| CGI.unescape(v) }
          hash[key] = val
        end
        hash
      end
    end
  end
end

module IMS::LTI
  class ToolConsumer
    def generateBasicLtiLaunchRequest
      request = IMS::LTI::Messages::BasicLtiLaunchRequest.new
      request.process_params(params)
      request.launch_url = launch_url
      request.consumer_key = consumer_key
      request.consumer_secret = consumer_secret
      request.nonce = nonce
      request.timestamp = timestamp
      request
    end
  end
end
