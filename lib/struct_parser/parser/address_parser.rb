module StructParser::Parsers
  class AddressParser < Parser
    def initialize(options={})
      super options
    end

    def sub_filters
      [
          ##
          # Parse
      -> (c) {
        m = /\b((s|singapore)?\s?(\(\d{6}\)|\d{6}))/i.match c.val
        # If match found, split into address and post code
        r = {}
        if m
          r[:address] = c.val.sub(m.captures[0], '').strip
          r[:postcode] = /[0-9]{6}/.match(m.captures[0]).captures[0]
        else
          r[:address] = c.val
        end
        c.val = r
        true
      }
      ]
    end
  end
end
