require "spec_helper"

describe IMS::LTI::Messages::ToolProxyRegistrationRequest do
  let(:tc) {IMS::LTI::ToolConsumer.new('12345', 'secret')}
  let(:request) {tc.generateToolProxyRegistrationRequest}

  it "generates a tool proxy registration request" do
    request.user_id = 'user_id'
    request.roles = 'teacher,student'
    request.tc_profile_url = 'http://www.example.com/profile'
    request.reg_key = 'test_launch'
    request.launch_presentation_return_url = 'http://www.example.com'
    params = request.generate_launch_data
  end

  it "automatically generate a reg_password" do
    password = request.reg_password
    password.should_not be_empty
    request.reg_password.should eql(password)
  end

  it "allows reg_password to be set manually" do
    request.reg_password = 'hot cakes'
    request.reg_password.should eql('hot cakes')
  end
end