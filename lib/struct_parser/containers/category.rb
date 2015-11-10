module StructParser::Containers
  class Category < StructParser::Container
    def assign_cell_squad(squad)
      children.each do |s|
        s.assign_cell_squad squad
      end
      self
    end

    def assign_row_squad(squad)
      children.each do |s|
        s.assign_row_squad squad
      end
      self
    end

    def assign_col_squad(squad)
      children.each do |s|
        s.assign_col_squad squad
      end
      self
    end

    def assign_sheet_squad(squad)
      children.each do |s|
        s.op_squad = squad
      end
      self
    end

    def drop_no_header
      children.map &:drop_no_header
    end

    def to_category!(options)
      cat = self.class.new
      children.each do |sheet|
        subcat = sheet.to_category! options
        cat.children += subcat.children
      end
      cat
    end

    def dup
      cat = self.class.new
      cat.children = self.children.each do |sheet|
        new_sheet = sheet.dup cat
        new_sheet.context[:name] = sheet.name unless sheet.name.blank?
      end
      cat
    end

  end
end