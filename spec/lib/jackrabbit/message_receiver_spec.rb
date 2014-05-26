require 'spec_helper'
require 'jackrabbit'

describe Jackrabbit::MessageReceiver do
  let(:channel) { double('channel') }
  let(:handler) do
    Proc.new do |message|
    end
  end

  describe '#initialize' do
    it 'returns a message reciever instance' do
      instance = Jackrabbit::MessageReceiver.new(channel, {}, &Proc.new {})
      expect(instance.channel).to be(channel)
      expect(instance.options).to eq({})
      expect(instance.handler).to respond_to(:call)
    end
  end

  describe '#handle' do
    let(:assertion) { double('assertion', asserted: false) }
    subject(:receiver) do
      Jackrabbit::MessageReceiver.new(channel) do |message|
        assertion.asserted(message)
      end
    end

    it 'calls to the handler block' do
      receiver.handle('info', 'message', 'payload')
      expect(assertion).to have_received(:asserted)
    end

    it 'calls the handler block with a message object with the correct properties set' do
      expect(assertion).to receive(:asserted) do |message|
        expect(message.info).to eq('info')
        expect(message.message).to eq('message')
        expect(message.payload).to eq('payload')
        expect(message.channel).to be(channel)
      end

      receiver.handle('info', 'message', 'payload')
    end
  end
end