require 'core_ext'

module Jackrabbit
  autoload :Exchange, 'jackrabbit/exchange'
  autoload :Config, 'jackrabbit/config'
  autoload :Client, 'jackrabbit/client'
  autoload :MessageReceiver, 'jackrabbit/message_receiver'
  autoload :Message, 'jackrabbit/message'

  def self.config(&block)
    Config.default(&block)
  end

  def self.new
    Client.new
  end
end