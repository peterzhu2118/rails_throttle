module RailsThrottle
  class Throttle
    def self.increment(key, options = {}, &block)
      raise "Key cannot be blank." if key.blank?

      increment = options[:increment] || 1
      limit = options[:limit] || 0
      period = options[:period] || 0

      value = RailsThrottle.backend.increment(key, increment)

      if value.nil?
        RailsThrottle.backend.write(key, increment, expires_in: period)

        value = increment
      elsif value > limit
        raise RailsThrottle::ThrottleError, "Limit exceeded for key `#{key}` with limit of #{limit}"
      end
      
      unless block.nil?
        if block.arity == 0
          block.call
        elsif block.arity == 1
          block.call(key)
        else
          block.call(key, value)
        end
      end

      value
    end

    def self.decrement(key, options = {})
      raise "Key cannot be blank." if key.blank?

      decrement = options[:decrement] || 1

      RailsThrottle.backend.decrement(key, decrement)
    end

    def self.throttled?(key, limit)
      raise "Key cannot be blank." if key.blank?

      value = RailsThrottle.backend.read(key) || 0

      return value >= limit
    end

    def self.reset(key)
      raise "Key cannot be blank." if key.blank?

      RailsThrottle.backend.delete(key)
    end
  end
end