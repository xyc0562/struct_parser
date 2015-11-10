module StructParser
  module Exceptions

    class Error < StandardError
      attr_accessor :location
      def initialize(msg=nil, backtrace=nil)
        @location = {}
        e = super msg
        if backtrace
          e.set_backtrace backtrace
        end
        e
      end
    end

    class ParseError < Error;end

    class DupError < Error;end

    class UnreachableStateError < Error;end

    class NotFoundError < Error;end

  end
end