module StructParser
  class Container::Sheet < Container
    include StructParser::Classes
    # Together forms children
    attr_accessor :rows, :cols

    def dup(parent=nil)
      sheet = self.class.new parent: parent
      sheet.name = name
      sheet.load_matrix to_matrix
    end

    def header_row
      rows[0]
    end

    def op_squad=(squad)
      squad = { after_children: squad } unless squad.is_a? Hash
      @op_squad = squad
    end

    def run
      begin
        super
      rescue StandardError
        raise $!, "#{$!}, Sheet name: `#{name}`", $!.backtrace
      end
    end

    def name
      context[:name]
    end

    def name=(val)
      context[:name] = val
    end

    def get_cell(r, c)
      rows[r].children[c]
    end

    def initialize(options={})
      super options
      self.rows = []
      self.cols = []
    end

    def assign_cell_squad(squad)
      # Default action is before_children
      squad = { before_children: squad } unless squad.is_a? Hash
      squad = StructParser::Utils.flatten_val squad
      rows.each do |row|
        row.children.each do |cell|
          cell.op_squad = squad
        end
      end
      self
    end

    def assign_row_squad(squad)
      squad = { after_children: squad } unless squad.is_a? Hash
      squad = StructParser::Utils.flatten_val squad
      rows.each do |row|
        row.op_squad = squad
      end
      self
    end

    def assign_col_squad(squad)
      squad = { after_children: squad } unless squad.is_a? Hash
      squad = StructParser::Utils.flatten_val squad
      cols.each do |col|
        col.op_squad = squad
      end
      self
    end

    ##
    # Create a sub sheet
    def slice(xs, x, ys, y)
      m = []
      (xs..x).each do |i|
        srow = []
        m << srow
        (ys..y).each do |j|
          srow << rows[i].children[j].raw
        end
      end
      self.class.new.load_matrix m
    end

    def to_matrix
      rows.map do |r|
        r.children.map &:raw
      end
    end

    def load_matrix(m)
      col_count = 0
      m.each do |row|
        col_count = row.size if col_count < row.size
      end
      # Populate rows
      m.each_with_index do |srow, row_idx|
        row = Row.new parent: self, idx: row_idx, context: { val: {} }
        rows << row
        srow.each do |val|
          val = val.nil? ? nil : val.strip
          val = val.blank? ? nil : val
          Cell.new parent: row, context: { raw: val,
                                           val: val}, row: row
        end
        # Pad row to max width with nil values
        if srow.count < col_count
          (0...col_count - srow.count).each do
            Cell.new parent: row, context: { raw: nil }
          end
        end
      end
      # Populate cols
      (0...col_count).each do |i|
        col = Column.new parent: self, idx: i
        cols << col
        rows.each do |row|
          cell = row.children[i]
          cell.col = col
          col.children << cell
        end
      end
      self
    end

    ##
    # Drop columns without header
    def drop_no_header
      idx = -1
      # Means no value in header column
      while (idx+=1) < header_row.children.size && header_row.children[idx].raw.blank?
        drop_column idx
        idx -= 1
      end
    end

    def drop_column(idx)
      # Remove cols
      cols.delete_at idx
      # Remove each row's column
      rows.each do |row|
        row.delete_at idx
      end
      # Remove row in children's column
      children.select { |c| c.class == Row }.each do |row|
        row.delete_at idx
      end
    end

    def to_category!(options)
      anchor = options[:anchor]
      namer = options[:namer]
      cell_squad = anchor &
          -> (c) {
            # Create sheet
            self.val ||= {}
            cat = val[:cat] ||= Category.new
            # Probe for dimension
            dim = naive_probe_dimension c
            # Assign sheet name
            sub_sheet = slice *dim
             if namer.respond_to? :call
               sub_sheet.name = namer.call c
             else
               sub_sheet.name = name
             end
            cat.children << sub_sheet
          }
      assign_cell_squad cell_squad
      run
      # Return partitioned category
      val[:cat]
    end

    def naive_probe_dimension(cell)
      # Read until empty column or end of row for header
      x = xs = cell.row.idx
      y = ys = cell.col.idx
      # Get row
      cells = cell.row.children
      (ys...cells.size).each do |idx|
        c = cells[idx]
        break if c.raw.blank?
        y = idx
      end
      # col is a bit more tricky, we need to scan rows downwards
      # until one row is entirely empty in col range
      rows = cell.sheet.rows
      (xs...rows.size).each do |idx|
        row = rows[idx]
        break if row.children[ys..y].map(&:raw).map(&:blank?).all?
        x = idx
      end
      # Return tuple
      [xs, x, ys, y]
    end


  end
end
