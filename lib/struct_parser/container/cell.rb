module StructParser
  class Container::Cell < Container
    attr_accessor :row, :col, :sheet
    def initialize(options={})
      @row = options.delete :row
      @col = options.delete :col
      @sheet = @row.parent
      super options
    end

    def run
      begin
        super
      rescue StandardError
        raise $!, "#{$!}, Cell Index: `#{sheet_idx}`", $!.backtrace
      end
    end

    def right(options={})
      ignore_blank = options[:ignore_blank]
      if @row.children.size > @col.idx + 1
        n = @row.children[@col.idx + 1]
        if ignore_blank && n.raw.blank?
          n.right options
        else
          n
        end
      else
        nil
      end
    end

    def left(options={})
      ignore_blank = options[:ignore_blank]
      if @col.idx >= 1
        n = @row.children[@col.idx - 1]
        if ignore_blank && n.raw.blank?
          n.left options
        else
          n
        end
      else
        nil
      end
    end

    def up(options={})
      ignore_blank = options[:ignore_blank]
      if @row.idx >= 1
        n = @col.children[@row.idx - 1]
        if ignore_blank && n.raw.blank?
          n.up options
        else
          n
        end
      else
        nil
      end
    end

    def down(options={})
      ignore_blank = options[:ignore_blank]
      if @col.children.size > @row.idx + 1
        n = @col.children[@row.idx + 1]
        if ignore_blank && n.raw.blank?
          n.down options
        else
          n
        end
      else
        nil
      end
    end

    ##
    # Return header cell, default to first row
    def header
      @col.children[0]
    end

    ##
    # Check if cell resides in the first row
    def is_header?
      @row.is_header?
    end

    ##
    # Assuming last row to be footer
    def is_footer?
      @row.is_footer?
    end

    def data_for?(*header_vals)
      header_vals = header_vals.map &:squash_space_dc
      !is_header? && !header.raw.blank? && header_vals.include?(header.raw.squash_space_dc)
    end

    def sheet_idx
      "#{@row.sheet_idx}:#{@col.sheet_idx}"
    end

  end
end
