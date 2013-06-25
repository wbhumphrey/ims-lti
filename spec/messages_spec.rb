require "spec_helper"

describe IMS::LTI::Messages::Base do
  class Message1
    include IMS::LTI::Messages::Base
    register_parameter 'param1', required=true
  end

  class Message2
    include IMS::LTI::Messages::Base
    register_parameter 'param2', required=true
  end

  it 'defines accepted params for each request separately' do
    accepted_params = Message1.new.accepted_parameters
    accepted_params.should include 'param1'
    accepted_params.should_not include 'param2'

    accepted_params = Message2.new.accepted_parameters
    accepted_params.should include 'param2'
    accepted_params.should_not include 'param1'
  end
end
