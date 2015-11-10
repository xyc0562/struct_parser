module StructParser::Containers
  class Column < StructParser::Containers::Sequence
    def run
      begin
        super
      rescue StandardError
        raise $!, "#{$!}, Col Index: `#{sheet_idx}`", $!.backtrace
      end
    end

    def sheet_idx
      StructParser::Utils.idx_to_col idx
    end
  end
end
