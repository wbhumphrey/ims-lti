require "spec_helper"
describe IMS::LTI::Models::ToolConsumerProfile do
  let(:profile) {IMS::LTI::Models::ToolConsumerProfile.new}
  it "has default values" do
    profile.context.should_not be_nil
    profile.context = 'new_context'
    profile.context.should eql 'new_context'
  end

  it "fails validation with nothing set" do
    profile.should_not be_valid
  end

  it "generates params even when not valid" do
    profile.to_params.should be_a Hash
    require 'pry'
    binding.pry
  end
end
