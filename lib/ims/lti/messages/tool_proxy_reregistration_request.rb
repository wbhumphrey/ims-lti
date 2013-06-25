require 'securerandom'

module IMS::LTI
  module Messages
    class ToolProxyReregistrationRequest < ToolProxyRegistrationRequest
    end
  end
end

module IMS::LTI
  class ToolConsumer
    def ToolProxyReregistrationRequest
      request = IMS::LTI::Messages::ToolProxyReregistrationRequest.new
      request.process_params(params)
      request
    end
  end
end
