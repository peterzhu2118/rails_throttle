require "test_helper"

module RailsThrottle
  class ThrottleTest < Minitest::Test
    setup do
      @cache = ActiveSupport::Cache::MemoryStore.new

      RailsThrottle.backend = @cache
    end

    test ".throttle throws ThrottleError when over throttle limit" do
      times_ran = 0

      5.times do
        RailsThrottle::Throttle.increment "foo", limit: 5, period: 5.seconds do
          times_ran += 1
        end
      end

      assert_raises RailsThrottle::ThrottleError do
        RailsThrottle::Throttle.increment "foo", limit: 5, period: 5.seconds do
          times_ran += 1
        end
      end

      assert_equal 5, times_ran
    end

    test ".throttle on block with arity 0" do
      times_ran = 0

      RailsThrottle::Throttle.increment "foo", limit: 5, period: 5.seconds do
        times_ran += 1
      end

      assert_equal 1, times_ran
    end

    test ".throttle on block with arity 1" do
      times_ran = 0

      RailsThrottle::Throttle.increment "foo", limit: 5, period: 5.seconds do |key|
        assert_equal "foo", key

        times_ran += 1
      end

      assert_equal 1, times_ran
    end

    test ".throttle on block with arity 2" do
      times_ran = 0

      RailsThrottle::Throttle.increment "foo", limit: 5, period: 5.seconds do |key, value|
        assert_equal "foo", key
        assert_equal 1, value

        times_ran += 1
      end

      assert_equal 1, times_ran
    end

    test ".decrement decrements limit" do
      5.times do
        RailsThrottle::Throttle.increment "foo", limit: 5, period: 5.seconds
      end

      RailsThrottle::Throttle.decrement "foo"

      refute RailsThrottle::Throttle.throttled? "foo", 5
    end

    test ".throttled? returns false on nonexitant keys" do
      refute RailsThrottle::Throttle.throttled? "bar", 5
    end

    test ".throttled? returns false on not throttled keys" do
      4.times do
        RailsThrottle::Throttle.increment "foo", limit: 5, period: 5.seconds
      end

      refute RailsThrottle::Throttle.throttled? "foo", 5
    end

    test ".throttled? returns true on throttled keys" do
      5.times do
        RailsThrottle::Throttle.increment "foo", limit: 5, period: 5.seconds
      end

      assert RailsThrottle::Throttle.throttled? "foo", 5
    end

    test ".reset resets the counter for the throttle" do
      5.times do
        RailsThrottle::Throttle.increment "foo", limit: 5, period: 5.seconds
      end

      RailsThrottle::Throttle.reset "foo"

      refute RailsThrottle::Throttle.throttled? "foo", 5

      5.times do
        RailsThrottle::Throttle.increment "foo", limit: 5, period: 5.seconds
      end

      assert RailsThrottle::Throttle.throttled? "foo", 5
    end
  end
end