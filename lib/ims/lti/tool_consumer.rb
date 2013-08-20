require 'json'

module IMS::LTI
  # Class for implementing an LTI Tool Consumer
  class ToolConsumer
    include IMS::LTI::Extensions::Base
    include IMS::LTI::Params
    include IMS::LTI::RequestValidator

    attr_accessor :consumer_key, :consumer_secret, :launch_url, :timestamp, :nonce

    # Create a new ToolConsumer
    #
    # @param consumer_key [String] The OAuth consumer key
    # @param consumer_secret [String] The OAuth consumer secret
    # @param params [Hash] Set the launch parameters as described in LaunchParams
    def initialize(consumer_key, consumer_secret, params={})
      @consumer_key = consumer_key
      @consumer_secret = consumer_secret
      @launch_url = params['launch_url']
      self.params = params
    end
    
    def process_post_request(post_request)
      request = extend_outcome_request(OutcomeRequest.new)
      request.process_post_request(post_request)
    end

    # Set launch data from a ToolConfig
    #
    # @param config [ToolConfig]
    def set_config(config)
      @launch_url ||= config.secure_launch_url
      @launch_url ||= config.launch_url
      # any parameters already set will take priority
      @custom_params = config.custom_params.merge(@custom_params)
    end

    # Check if the required parameters for a tool launch are set
    def has_required_params?
      @consumer_key && @consumer_secret && @resource_link_id && @launch_url
    end

    # [Deprecated] Convenience method for generating the params for a
    # basic-lti-launch-request.
    #
    # Use generateBasicLtiLaunchRequest to create a request, and get the
    # params from the request object instead.
    def generate_launch_data
      generateBasicLtiLaunchRequest.generate_launch_data
    end

    def generate_profile
      profile = IMS::LTI::Models::ToolConsumerProfile.new('')
      profile.product_instance = IMS::LTI::Models::ProductInstance.new('')


    end
  end
end
