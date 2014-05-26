# Jackrabbit

Jackrabbit makes interacting with RabbitMQ a little nicer.

## Installation

Add this line to your application's Gemfile:

    gem 'jackrabbit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jackrabbit

## Usage

### Configuration

Jackrabbit has an assumption that you're working with 1 exchange most of the time. It does allow you to work with multiple. But configuration on the class pertains to 1 exchange.

    Jackrabbit.config do |c|
      c.exchange_type = 'topic'
      c.exchange_name = 'my.exchange'
      c.exchange_options = {}

      c.connection = Bunny.new
      c.connection.start
    end

Jackrabbit will use the Bunny gem connection you pass in. You must have called #start on it yourself however.
The reason for this is because in specs you can swap the connection out for something like [BunnyHair](http://github.com/thunderboltlabs/bunny_hair) which tries to mimick Bunny but in memory.

### Clients

Calling `Jackrabbit.new` will return a `Jackrabbit::Client` object. This is the object you'll be interfacing the most with.

    client = Jackrabbit.new
    #=> Jackrabbit::Client

### Bonded Queues

With the client object you can create queues that are bonded to your exchange automatically. This is handy since binding queues become tedious when you do it a lot. For example:

    client.bonded_queue('my.queue.name', binding: { routing_key: 'key.#' }) do |message|
      puts message.payload
      puts message.delivery_info
      puts message.message
    end

When you pass a block to the bonded queue this is the block that is called for each message that the queue receives. It is your consumer.

### Messages

In the subscription block from bonded queue, you aren't given info, delivery, and payload arguments like the Bunny gem provides. Instead you get a single object that incapsulates all of them and gives some nice behavior.

For example, message acknowledgements become very simple.

    client.bonded_queue('my.queue.name', binding: { routing_key: 'key.#' }, subscription: { ack: true}) do |message|
      puts message.payload

      # acknowledge the message to RabbitMQ
      message.acknowledge!
    end

Passing in the additional key of `subscription: { ack: true }` details that you want to explicitly ack messages.


### Multiple Exchanges

There might be an instance that you want to maybe use a different connection with a different exchange. To do this you can instantiate clients manually with a separate configuration.

    config = Jackrabbit::Config.new
    config.exchange_type = 'direct'
    config.exchange_name = 'direct.exchange'
    config.connection = Bunny.new

    client = Jackrabbit::Client.new(config)

Now your client object will interact with the other exchange you've detailed.

## Contributing

1. Fork it ( https://github.com/bobbytables/jackrabbit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
