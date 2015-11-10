module StructParser::Parsers
  # Parser generator for mapped fields (typically values for selection or checkbox group)
  class MapParser < Parser
    def initialize(options={})
      @mapping = options.delete :mapping
      super options
    end

    def sub_filters
      [
          ##
          # Parse
      -> (c) {
        # If a mapped value is found
        if (val = @mapping[c.val])
          c.val = val
        elsif @mapping.has_key? :default
          c.val = @mapping[:default]
          # If neither direct mapping nor default value is available, throw exception
        else
          parse_error "`#{c.val}` is not valid. set `default: xxx` in the mapping if needed."
        end
        true
      }
      ]
    end
  end
end