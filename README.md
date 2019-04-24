# RailsThrottle [![CircleCI](https://circleci.com/gh/peterzhu2118/rails_throttle/tree/master.svg?style=svg)](https://circleci.com/gh/peterzhu2118/rails_throttle/tree/master) [![Gem Version](https://badge.fury.io/rb/rails_throttle.svg)](https://badge.fury.io/rb/rails_throttle)

RailsThrottle is a simple library used to throttle code in your Rails application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rails_throttle", "~> 0.1.0"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_throttle

## Usage

- See full documentation here: 
- Example configuration (for production, you can configure other environments in a similar way):
    ```ruby
    # In config/environments/production.rb
    RailsThrottle.backend = ActiveSupport::Cache::RedisStore.new "localhost:6379/0"

    # Alternatively, also supports any of the other caching strategies of ActiveSupport::Cache.
    # For details, see https://api.rubyonrails.org/classes/ActiveSupport/Cache.html.
    ```
- Example usage:
    ```ruby
    RailsThrottle::Throttle.increment("foo", limit: 4, period: 2.seconds) # => 1
    RailsThrottle::Throttle.increment("foo", limit: 4, period: 2.seconds) # => 2
    RailsThrottle::Throttle.decrement("foo", limit: 4, period: 2.seconds) # => 1
    RailsThrottle::Throttle.reset("foo")
    RailsThrottle::Throttle.increment("foo", limit: 4, period: 2.seconds, increment: 4) # => 4
    RailsThrottle::Throttle.increment("foo", limit: 4, period: 2.seconds) # => RailsThrottle::ThrottleError
    RailsThrottle::Throttle.throttled?("foo", limit: 5) # => true

    # ... wait 2 seconds ...

    RailsThrottle::Throttle.throttled?("foo", limit: 5) # => false
    ```

## Development

Just the usual clone and `bundle` to install dependencies. Run `rake test` to run tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/peterzhu2118/rails_throttle.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
