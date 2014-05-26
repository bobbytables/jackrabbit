require 'spec_helper'
require 'jackrabbit'

describe Jackrabbit::Client do
  subject(:client) { Jackrabbit::Client.new(config) }

  let(:config) do
    Jackrabbit::Config.new.tap do |config|
      config.exchange_name = 'bunk'
      config.exchange_type = 'topic'
      config.connection = BunnyHair.new
    end
  end

  describe '#config' do
    it 'is defaulted to the global config' do
      client = Jackrabbit::Client.new
      expect(client.config).to be(Jackrabbit.config)
    end

    it 'can be injected in on initialization' do
      config = double
      client = Jackrabbit::Client.new(config)
      expect(client.config).to be(config)
    end
  end

  describe '#channel' do
    it 'returns the default channel' do
      expect(client.channel).to_not be_nil
    end
  end

  describe '#exchange' do
    it 'returns an exchange' do
      expect(client.exchange.name).to eq('bunk')
      expect(client.exchange.type).to eq(:topic)
    end

    it 'raises an error when the config specifies an incorrect type' do
      config.exchange_type = 'nothin'
      expect { client.exchange }.to raise_error(Jackrabbit::Client::InvalidExchangeType)
    end
  end

  describe '#publish' do
    it 'pushes a message onto the exchange' do
      expect(client.exchange).to receive(:publish).with(
        'message', anything
      ).and_call_original

      client.publish('message')
    end

    it 'publishes with options passed' do
      expect(client.exchange).to receive(:publish).with(
        'payload', routing_key: 'bunk'
      ).and_call_original

      client.publish('payload', routing_key: 'bunk')
    end
  end

  describe '#bonded_queue' do
    def test_queues
      client.channel.test_queues
    end

    it 'creates a queue' do
      client.bonded_queue('name')
      expect(test_queues[0].name).to eq('name')
    end

    it 'creates a queue with options set' do
      client.bonded_queue('name', durable: true, exclusive: true, auto_delete: true)
      expect(test_queues[0]).to be_auto_delete
      expect(test_queues[0].options[:durable]).to be_truthy
      expect(test_queues[0].options[:exclusive]).to be_truthy
    end

    it 'creates a consumer for the queue' do
      client.bonded_queue('name')
      expect(test_queues.first.consumers.size).to be(1)
    end

    it 'handles the messages in the block when the exchange gets a message' do
      assertion = double('foo', asserted: false)
      client.bonded_queue('bunk') do |message|
        assertion.asserted(message)
      end

      client.publish('message')

      expect(assertion).to have_received(:asserted).with(instance_of(Jackrabbit::Message)).once
    end

    context 'binding' do
      it 'passes binding options to the queue binding' do
        queue = BunnyHair::Queue.new('bunk')
        allow(client.channel).to receive(:queue).and_return(queue)
        expect(queue).to receive(:bind).with(client.exchange, routing_key: 'bunk')

        client.bonded_queue('foo', binding: { routing_key: 'bunk' })
      end
    end

    context 'subscriptions' do
      it 'passes subscription options to the queue subscription' do
        queue = BunnyHair::Queue.new('bunk')
        allow(client.channel).to receive(:queue).and_return(queue)
        expect(queue).to receive(:subscribe).with(ack: true)

        client.bonded_queue('foo', subscription: { ack: true })
      end
    end
  end
end