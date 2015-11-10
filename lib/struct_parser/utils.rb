module StructParser::Utils
  class << self
    def idx_to_col(idx)
      r = (idx%26 + 65).chr
      while (idx = idx/26 - 1) >= 0
        r = (idx%26 + 65).chr + r
      end
      r
    end

    def get_in(m, *keys)
      r = m
      keys.each do |k|
        if r.is_a? Hash || r.is_a?(Array)
          r = r[k]
        else
          return nil
        end
      end
      r
    end

    def assoc_in(m, val, *keys)
      last = keys.size - 1
      (0..last).each do |idx|
        k = keys[idx]
        if m[k].nil?
          m[k] = {}
        end
        if last == idx
          m[k] = val
        else
          m = m[k]
        end
      end
      m
    end

    def text_anchor(str)
      -> (cell) {
        cell.raw == str
      }
    end

    def offset_namer(x, y)
      -> (anchor_cell) {
        sheet = anchor_cell.parent.parent
        sheet.get_cell(anchor_cell.row.idx + x, anchor_cell.col.idx + y).raw
      }
    end

    def col_ops(*tuples)
      tuples.map do |tuple|
        StructParser::Guard::HeaderGuard.new(tuple[0]).plus(*tuple[1..-1])
      end
    end

    def flatten_val(m)
      m.each do |k,v|
        m[k] = [v].flatten
      end
    end

  end
end