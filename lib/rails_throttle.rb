require "active_support/cache"

require "rails_throttle/version"
require "rails_throttle/throttle"

module RailsThrottle
  mattr_accessor :backend

  class ThrottleError < StandardError
    def initialize(message = nil)
      super(message)
    end
  end
end

RailsThrottle.backend ||= ActiveSupport::Cache::MemoryStore.new
