require 'vagrant-vmpooler/config'
require 'rspec/its'

RSpec.configure do |config|
  # ...
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

describe VagrantPlugins::Vmpooler::Config do
  let(:instance) { described_class.new }

  describe "defaults" do
    subject do
      instance.tap do |o|
        o.finalize!
      end
    end

    its("os") {should be_nil}
    its("verbose") {should be false}
    its("password") {should be_nil}
    its("ttl") {should be_nil}
    its("disk") {should be_nil}
  end

  describe "overriding defaults" do
      [:os, :verbose, :password, :ttl, :disk].each do |attribute|
        it "should not default #{attribute} if overridden" do
          # but these should always come together, so you need to set them all or nothing
          instance.send("url=".to_sym, "foo")
          instance.send("token=".to_sym, "foo")
          instance.send("os=".to_sym, "foo")
          instance.send("#{attribute}=".to_sym, "foo")
          instance.finalize!
          instance.send(attribute).should == "foo"
        end
      end
  end
end
