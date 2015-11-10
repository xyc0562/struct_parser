module StructParser::Guards
  class HeaderGuard < StructParser::Operation
    def initialize(*cols)
      options = cols.extract_options!
      super options
      @cols = cols
    end

    def run(c)
      c.data_for? *@cols
    end
  end
end
