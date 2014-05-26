module Jackrabbit
  class MessageReceiver
    attr_reader :channel, :options, :handler

    def initialize(channel, options = {}, &block)
      @channel = channel
      @options = options
      handle_with(&block) if block_given?
    end

    def handle(info, message, payload)
      @handler.call Message.new(info, message, payload, channel)
    end

    private

    def handle_with(&block)
      @handler = block
    end
  end
end