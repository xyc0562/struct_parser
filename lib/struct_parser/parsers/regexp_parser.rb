module StructParser::Parsers
  # Parser generator for mapped fields (typically values for selection or checkbox group)
  class RegexpParser < StructParser::Parser

    def initialize(options={})
      @regexp = options.delete :regexp
      super options
    end

    def sub_filters
      [ regexp_guard(@regexp) ]
    end
  end
end