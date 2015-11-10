module StructParser::Operations
  class ColumnAssignOperation < Operation
    def initialize(options={})
      super options
      @col = options[:col]
    end

    def run(c)
      unless c.row.get_val @facade
        c.row.set_val({}, @facade)
      end
      m = c.row.get_val @facade
      if @col.is_a?(Array) && c.val.is_a?(Hash)
        @col.each do |col|
          m[col] = c.val[col]
        end
      else
        m[@col] = c.val
      end
      true
    end
  end
end