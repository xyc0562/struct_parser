module StructParser
  extend StructParser::Classes
  # Monkey patch core classes to behave like Operation
  require 'struct_parser/core_ext/proc'
  require 'struct_parser/core_ext/array'
  require 'struct_parser/core_ext/string'
  require 'struct_parser/core_ext/symbol'
  class << self
    public
    def read_csv_category(paths, options={})
      cat = Category.new
      paths.each do |path|
        result = read_csv(path, options)
        # If csv is further read into a category, add all its sheets
        if result.is_a? Category
          cat.children += result.children
        else
          # Otherwise it has to be a sheet
          cat.children << result
        end
      end
      cat
    end

    def read_csv(path, options={})
      if File.directory? path
        cat = Category.new
        (Dir[Pathname.new(path).join('*.csv')] + Dir[Pathname.new(path).join('*.CSV')]).each do |p|
          c = _read_single_csv p, options
          if c.is_a? Category
            cat.children += c.children
          else
            cat.children << c
          end
        end
        cat
      else
        _read_single_csv path, options
      end
    end

    def find_csv(path)
      if File.directory? path
        Dir[Pathname.new(path).join('*.csv')] + Dir[Pathname.new(path).join('*.CSV')]
      else
        [path]
      end
    end

    private
    def _read_single_csv(path, options={})
      name = Pathname.new(path).basename
      # Read file
      s = Roo::CSV.new(path).sheet(0)
      sheet = Sheet.new context: { name: name }
      # Acquire dimension of sheet
      row_count = s.count
      # Create matrix
      m = []
      (1..row_count).each do |i|
        row = []
        m << row
        s.row(i).each do |val|
          row << val
        end
      end
      sheet.load_matrix m
      # Check if needs to read directly to category
      if (to_cat = options[:to_category])
        sheet.to_category! to_cat
      else
        sheet
      end
    end

  end

end
