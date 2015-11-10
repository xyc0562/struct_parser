module StructParser
  module OperationBody
    def initialize(options={})
      @facade = [options[:facade] || []].flatten
    end

    def run(*args)
      # To be overridden by subclasses
    end

    ##
    # Compose other operations into a new one
    # composed operations only execute
    # if previous operation returns truthy
    def plus(*ops)
      this = self
      comp = Class.new(Operation) do
        define_method :run do |*args|
          success = this.run *args
          ops.each do |op|
            break unless success
            success = op.run *args
          end
          success
        end
      end
      # Return an instance
      comp.new
    end

    ##
    # Similar to plus
    # Main difference is that
    # composed operations execute regardless of
    # whether previous operation returns truthy
    def plus_i(*ops)
      this = self
      comp = Class.new(Operation) do
        define_method :run do |*args|
          if this.run *args
            ops.each do |op|
              op.run *args
            end
            true
          else
            false
          end
        end
      end
      # Return an instance
      comp.new
    end

    def &(op)
      plus op
    end

    def |(op)
      this = self
      comp = Class.new(Operation) do
        define_method :run do |*args|
          return true if this.run *args
          return op.run *args
        end
      end
      # Return an instance
      comp.new
    end

    def +(op)
      this = self
      comp = Class.new(Operation) do
        define_method :run do |*args|
          this.run *args
          op.run *args
          true
        end
      end
      # Return an instance
      comp.new
    end


    protected
    def except_m
      StructParser::Exceptions
    end

    def unreachable_state_error(msg)
      raise except_m::UnreachableStateError msg
    end
  end
end
