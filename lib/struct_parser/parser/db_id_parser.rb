module StructParser::Parsers
  # Determine id of a row in DB table based on column values of that table
  class DbIdParser < Parser

    ##
    # options:
    # +col+ column
    # +model+ ActiveRecord model class of table from which to fetch id
    def initialize(options)
      options = {
          error_on_fail: true,
          ignores_on_fail: []
      }.merge options

      @col = options.delete :col
      @model = options.delete :model
      @error_on_fail = options.delete :error_on_fail
      @ignores_on_fail = options.delete :ignores_on_fail
      super options
    end

    def sub_filters
      [
      -> (c) {
        # If col is nil, there is no need to fetch
        return false if c.val.nil?
        obj = @model.find_by @col => c.val
        if obj
          c.val = obj.id
          true
        else
          msg = "#{@model.name} entry with `#{@col}` = `#{c.val}` not found."
          if @error_on_fail && !@ignores_on_fail.include?(c.val)
            raise except_m::NotFoundError.new msg
          else
            puts "#{msg} Ignored..."
          end
          false
        end
      }
      ]
    end
  end
end