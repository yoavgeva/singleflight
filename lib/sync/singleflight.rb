# frozen_string_literal: true

require 'concurrent'

module Sync
  class SingleFlight
    def initialize
      # Initialize a thread-safe map to store ongoing calls
      @calls = Concurrent::Map.new
    end
    # Executes a block of code associated with a given key.
    # Ensures that only one execution happens for the same key at a time.
    # @param key [Object] the key to identify the block of code
    # @yield the block of code to be executed
    # @return [Object] the result of the block execution
    def execute(key)
      # Retrieve the call associated with the key
      call = @calls[key]
      if call.nil?
        # If no call exists, create a new one
        call = Call.new
        other = @calls.put_if_absent(key, call)
        if other.nil?
          begin
            # Execute the block and return the result
            return call.exec { yield }
          ensure
            # Ensure the call is removed from the map after execution
            @calls.delete(key)
          end
        else
          # If another call was added concurrently, use that one
          call = other
        end
      end
      # Wait for the existing call to complete and return its result
      call.await
    end

    class Call
      def initialize
        # Initialize synchronization primitives
        @lock = Mutex.new
        @finished = false
        @result = nil
        @exc = nil
        @condition = ConditionVariable.new
      end

      def finished(result, exc)
        @lock.synchronize do
          # Mark the call as finished and store the result or exception
          @finished = true
          @result = result
          @exc = exc
          # Notify all waiting threads
          @condition.broadcast
        end
      end

      def await
        @lock.synchronize do
          # Wait until the call is finished
          @condition.wait(@lock) until @finished
          # Raise the exception if one occurred
          raise @exc if @exc
          # Return the result
          @result
        end
      end

      def exec
        result = nil
        exc = nil
        begin
          # Execute the block and store the result
          result = yield
          result
        rescue => e
          # Capture any exception that occurs
          exc = e
          raise e
        ensure
          # Mark the call as finished with the result or exception
          finished(result, exc)
        end
      end
    end
  end
end