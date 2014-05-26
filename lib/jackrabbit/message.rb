module Jackrabbit
  class Message
    attr_reader :info, :message, :payload, :channel

    def initialize(info, message, payload, channel)
      @info = info
      @message = message
      @payload = payload
      @channel = channel
    end

    def acknowledge!
      channel.acknowledge(info.delivery_tag, false)
    end
  end
end