module Jackrabbit
  class Config
    def self.default(&block)
      (@default ||= new).tap do |config|
        yield config if block_given?
      end
    end

    attr_accessor :exchange_name, :exchange_type, :connection
    attr_accessor :exchange_options

    def initialize
      @exchange_options = {}
    end
  end
end