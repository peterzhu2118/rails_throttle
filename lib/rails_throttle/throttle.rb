module RailsThrottle
  class Throttle
    # Increments the counter for a given key.
    #
    # @param [String] key The key that uniquely identifies this throttle operation.
    # @param [Hash] options The options to this increment.
    # @option options [Integer] :increment The amount to increment the counter by, defaults to 1 if not provided.
    # @option options [Integer] :limit The maximum value the key can take before it is throttled (i.e. this key will
    #   be throttled once exceeded this limit).
    # @option options [Integer] :period The period of time (in seconds) which this throttle applies, the throttle will
    #   expire after this number of seconds.
    # @yield [key, value] Yields up to two parameters (you can choose whether you want zero, one, or two of these
    #   parameters).
    # @yieldparam [String] key The key that was passed in.
    # @yieldparam [Integer] value The current value of the throttle counter.
    # @return [Integer] The value of the block, or the current value of the throttle counter if no block is given.
    def self.increment(key, options = {}, &block)
      raise "Key cannot be blank" if key.blank?

      increment = options[:increment] || 1
      limit = options[:limit]
      period = options[:period]

      raise "Must specify :limit in the parameters" if limit.nil?
      raise "Must specify :period in the parameters" if period.nil?

      value = RailsThrottle.backend.increment(key, increment, expires_in: period)

      if value.nil?
        RailsThrottle.backend.write(key, increment, expires_in: period)

        value = increment
      end

      if value > limit
        RailsThrottle.backend.decrement(key, increment, expires_in: period)
        raise RailsThrottle::ThrottleError, "Limit exceeded for key `#{key}` with limit of #{limit}"
      end

      unless block.nil?
        if block.arity.zero?
          block.call
        elsif block.arity == 1
          block.call(key)
        else
          block.call(key, value)
        end
      else
        value
      end
    end

    # Decrements the counter for a given key.
    #
    # @param [String] key The key that uniquely identifies this throttle operation.
    # @param [Hash] options The options to this increment.
    # @option options [Integer] :decrement The amount to decrement the counter by, defaults to 1 if not provided.
    # @option options [Integer] :period The period of time (in seconds) which this throttle applies, the throttle will
    #   expire after this number of seconds.
    # @return [Integer] The current value of the throttle counter.
    def self.decrement(key, options = {})
      raise "Key cannot be blank." if key.blank?

      decrement = options[:decrement] || 1
      period = options[:period]

      raise "Must specify :period in the parameters" if period.nil?

      RailsThrottle.backend.decrement(key, decrement, expires_in: period)
    end

    # Returns true if the key is throttled, false otherwise.
    #
    # @param [String] key The key that uniquely identifies this throttle operation.
    # @param [Hash] options The options to this increment.
    # @option options [Integer] :limit The maximum value the key can take before it is throttled (i.e. this key will
    #   be throttled once exceeded this limit).
    # @return [Boolean] True if the key is throttled, false otherwise.
    def self.throttled?(key, options = {})
      raise "Key cannot be blank." if key.blank?

      limit = options[:limit]

      raise "Must specify :limit in the parameters" if limit.nil?

      value = RailsThrottle.backend.read(key) || 0

      value >= limit
    end

    # Resets a key so that it is no longer throttled.
    #
    # @param [String] key The key that uniquely identifies this throttle operation.
    def self.reset(key)
      raise "Key cannot be blank." if key.blank?

      RailsThrottle.backend.delete(key)
    end
  end
end
