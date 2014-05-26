require 'spec_helper'

describe Jackrabbit::Message do
  describe '#acknowledge!' do
    let(:channel) { double('channel', acknowledge: false) }
    let(:info) { double('info', delivery_tag: 1) }

    subject(:message) { Jackrabbit::Message.new(info, double, double, channel) }

    it 'acknowledges the message to the channel' do
      expect(channel).to receive(:acknowledge).with(info.delivery_tag, false)
      message.acknowledge!
    end
  end
end