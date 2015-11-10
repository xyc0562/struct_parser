module StructParser::Containers
  class Row < StructParser::Containers::Sequence
    ##
    # Assuming first row to be header, this may need to change
    def is_header?
      idx == 0
    end

    def not_header?
      !is_header?
    end

    def dup(parent)
      row = self.class.new parent: parent
      row.children = self.children.each do |cell|
        cell.dup row
      end
      row
    end

    ##
    # Assuming last row to be footer
    def is_footer?
      idx == parent.rows.size - 1
    end

    def run
      begin
        super
      rescue StandardError
        raise $!, "#{$!}, Row Index: `#{sheet_idx}`", $!.backtrace
      end
    end

    def sheet_idx
      idx + 1
    end

  end
end
