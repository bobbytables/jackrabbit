require 'spec_helper'
require 'jackrabbit'

describe Jackrabbit::Config do
  def has_a_setting_for(setting)
    value = 'bunk'
    expect(subject).to respond_to("#{setting}=")
    subject.send("#{setting}=", value)

    expect(subject.send(setting)).to be(value)
  end

  describe '.default' do
    it 'returns a default instance of the config' do
      config = Jackrabbit::Config.default
      expect(config).to be_instance_of(Jackrabbit::Config)
      expect(config).to be(Jackrabbit::Config.default)
    end

    it 'yields the instance to a block when passed in' do
      expect {|b| Jackrabbit::Config.default(&b) }.to yield_with_args(instance_of(Jackrabbit::Config))
    end
  end

  describe 'Settings' do
    it { has_a_setting_for(:exchange_name) }
    it { has_a_setting_for(:exchange_type) }
    it { has_a_setting_for(:exchange_options) }
    it { has_a_setting_for(:connection) }
  end
end