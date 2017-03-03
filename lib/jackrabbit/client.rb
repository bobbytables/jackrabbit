module Jackrabbit
  class Client
    InvalidExchangeType = Class.new(StandardError)

    attr_reader :config
    delegate :connection, to: :config

    def initialize(config = Jackrabbit.config)
      @config = config
    end

    def channel
      @channel ||= connection.create_channel
    end

    def exchange
      if %w(fanout direct topic).include?(config.exchange_type)
        @exchange ||= channel.send(config.exchange_type, config.exchange_name, config.exchange_options)
      else
        raise InvalidExchangeType, "The exchange type '#{config.exchange_type}' is invalid"
      end
    end

    def publish(message, options = {})
      exchange.publish(message, options)
    end

    def bonded_queue(name, options = {}, &block)
      queue_opts, binding_opts, sub_options = split_options(options)

      queue = self.queue(name, queue_opts)
      receiver = MessageReceiver.new(channel, &block)

      queue.bind(exchange, binding_opts)

      queue.subscribe(sub_options) do |info, message, payload|
        receiver.handle(info, message, payload)
      end
    end

    def queue(name, options)
      channel.queue(name, options)
    end

    private

    def split_options(options)
      binding_options = options.delete(:binding) || {}
      sub_options = options.delete(:subscription) || {}

      return [options, binding_options, sub_options]
    end
  end
end
