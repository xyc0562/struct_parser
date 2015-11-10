module StructParser::Parsers
  # Parser generator for mapped fields (typically values for selection or checkbox group)
  class UpcaseParser < StructParser::Parser

    def initialize(options={})
      super options
    end

    def sub_filters
      [ -> (c) {
        c.val = c.val.upcase
        true
      } ]
    end
  end
end
