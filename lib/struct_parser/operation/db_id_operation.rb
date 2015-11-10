module StructParser::Operations
  class DbIdOperation < Operation
    attr_accessor :options

    # +model+ is an active record class such as Student
    # +id_group+ is an array of fields for identifying a row
    # +key+ is the key upon which to assign fetched id in container context object
    def initialize(options)
      super options
      self.options = options
      @facades = self.options[:facades] || [[]]
      @model = self.options[:model]
      @id_group = [self.options[:id_group] || []].flatten
      @key = self.options[:key]
    end

    def run(c)
      # Check for existing entry
      id_vals = c.get_val(@facade).slice(*@id_group).compact
      existing = @model.find_by id_vals
      raise except_m::NotFoundError.new "#{@model} with id_group: #{id_vals} not found." unless existing
      # Assign key
      @facades.each do |f|
        c.set_val existing.id, f, @key
      end
      true
    end

  end
end