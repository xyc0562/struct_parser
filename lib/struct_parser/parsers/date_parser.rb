module StructParser::Parsers
  class DateParser < StructParser::Parser
    def initialize(options={})
      super options
      @format = options.delete :format
    end

    def sub_filters
      [
          ##
          # Parse
          -> (c) {
            if @format
              c.val = Date.strptime c.val, @format
            else
              c.val = Date.parse c.val
            end
            true
          }
      ]
    end
  end
end