module StructParser::Parsers
  class EmailParser < Parser

    def sub_filters
      [
          # Email address regexp
          regexp_guard(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/)
      ]
    end
  end
end
