module StructParser
  ##
  # Root of parser hierarchy
  class Parser < Operation
    # A list of filters through which container flows
    attr_accessor :filters, :options

    def initialize(options={})
      super()
      self.options = { nil_val_filter: true,
                       cont_nil: false, # Whether to call proceeding filters when a nil val is encountered
                       allow_nil: true }.merge options
      self.filters = options[:filters] || []
      # Append pre filters if needed
      self.filters << nil_val_filter if self.options[:nil_val_filter]
      # Append subclass filters
      self.filters += sub_filters
    end

    ##
    # Parse a container
    def run(container)
      success = true
      filters.each do |filter|
        # If filter returns falsey, there is no need to continue
        success = filter.run container
        break unless success
      end
      success
    end

    protected
    ##
    # To be overridden by subclass
    def sub_filters
      []
    end

    ##
    # Generate a filter acting as a regexp guard
    def regexp_guard(regexp)
      -> (c) {
        unless regexp =~ c.val
          parse_error "`#{c.val}` is not a valid input for regexp: /#{regexp.to_s[7..-2]}/"
        end
        true
      }
    end

    def parse_error(msg)
      raise except_m::ParseError.new "#{msg}"
    end

    def nil_val_filter
      # Remove nil values
      -> (c) {
        if c.val.blank? || %w(nil nill null -).include?(c.val.downcase)
          c.val = nil
          parse_error 'nil is not allowed!' unless options[:allow_nil]
          options[:cont_nil] ? true : false
        else
          true
        end
      }
    end

  end
end
