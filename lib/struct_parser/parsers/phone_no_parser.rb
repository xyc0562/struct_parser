module StructParser::Parsers
  class PhoneNoParser < StructParser::Parser
    def initialize(options={})
      super options
    end

    def sub_filters
      [regexp_guard(/^\+?(65)?([1-9]\d{7})$/),
       ##
       # Parse
       -> (c) {
         # If match found, split into address and post code
         r = {}
         if (fm = /^\+?(65)?([1-7]\d{7})$/.match c.val)
           r[:number] = fm.captures[1]
           r[:phone_number_type] = Constants::Enum::PHONE_NUMBER_HOME
         elsif (mm = /^\+?(65)?([8-9]\d{7})$/.match c.val)
           r[:number] = mm.captures[1]
           r[:phone_number_type] = Constants::Enum::PHONE_NUMBER_MOBILE
         end
         c.val = r
         true
       }
      ]
    end
  end
end