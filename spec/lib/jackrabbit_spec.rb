require 'spec_helper'
require 'jackrabbit'

describe Jackrabbit do
  describe '.config' do
    it 'returns the default configuration object' do
      config = double
      allow(Jackrabbit::Config).to receive(:default).and_return(config)

      expect(Jackrabbit.config).to be(config)
    end

    it 'yields the default configuration' do
      expect {|b| Jackrabbit.config(&b) }.to yield_with_args(Jackrabbit::Config.default)
    end
  end

  describe '.new' do
    it 'returns a Jackrabbit::Client object' do
      expect(Jackrabbit.new).to be_instance_of(Jackrabbit::Client)
    end

    it 'returns a client with the config set' do
      client = Jackrabbit.new
      expect(client.config).to be(Jackrabbit.config)
    end
  end
end