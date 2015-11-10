module StructParser::Parsers
  class IntParser < StructParser::Parser

    def sub_filters
      [
          ##
          # Format guard
          regexp_guard(/^[0-9]+$/),
          ##
          # Parse
          -> (c) {
            c.val = c.val.to_i
            true
          }
      ]
    end
  end
end
