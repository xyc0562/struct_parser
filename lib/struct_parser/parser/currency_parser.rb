module StructParser::Parsers
  class CurrencyParser < Parser
    def initialize(options={})
      super options
    end

    def sub_filters
      [
          ##
          # Parse
      -> (c) {
        m = /(\(([0-9]*\.?[0-9]+)\)|[-+]?[0-9]*\.?[0-9]+)/.match c.val
        if m
          s = m.captures[0]
          if s[0] == '('
            num = m.captures[1].to_d * -1
          else
            num = s.to_d
          end
          c.val = num
        else
          c.val = 0
        end
        true
      }
      ]
    end
  end
end