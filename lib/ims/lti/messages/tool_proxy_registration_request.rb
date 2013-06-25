require 'securerandom'

module IMS::LTI
  module Messages
    class ToolProxyRegistrationRequest
      include IMS::LTI::Messages::Base

      register_parameters %w{
        reg_key
        reg_password
        tc_profile_url
        launch_presentation_return_url
      }, required=true

      def reg_password
        @reg_password ||= SecureRandom.uuid
      end

      def lti_message_type
        'ToolProxyRegistrationRequest'
      end
    end
  end
end

module IMS::LTI
  class ToolConsumer
    def generateToolProxyRegistrationRequest
      request = IMS::LTI::Messages::ToolProxyRegistrationRequest.new
      request.process_params(params)
      request
    end
  end
end
