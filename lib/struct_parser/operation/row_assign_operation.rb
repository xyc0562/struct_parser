module StructParser::Operations
  class RowAssignOperation < Operation
    def initialize(options={})
      super options
      @key = options[:key]
    end

    def run(c)
      unless c.parent.get_val @facade
        c.parent.set_val({}, @facade)
      end
      m = c.parent.get_val @facade
      if c.val.is_a?(Hash) && (row_key = c.val[@key]).present?
        m[row_key] ||= []
        m[row_key] << c.val
        true
      else
        false
      end
    end
  end
end
