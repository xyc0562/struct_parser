module StructParser::Operations
  class RowInsertOperation < Operation
    # +model+ is an active record class such as Student
    # +id_group+ is an array of fields for identifying a row,
    #   because pk is unlikely available on a spreadsheet
    # +dup_plan+ dictates strategy to be used if a duplicate
    #   entry is found in +model+ table using id_group, available options are:
    #   +:fail+ raise +DupError+
    #   +:update+ update existing records with row value
    #   +:skip+ skip row insertion
    # +cols+ array of columns to insert, if not set, all columns will be inserted
    # +defaults+ hash of default key values/generators
    # +skip_if_all_nils+ array of keys, if ALL nil, will cause operation to skip
    # +skip_if_any_nils+ array of keys, if any nil, will cause operation to skip
    attr_accessor :options
    def initialize(options={})
      super options
      self.options = { dup_plan: :fail }.merge options
      @model = self.options[:model]
      @id_group = [self.options[:id_group] || []].flatten
      @dup_plan = self.options[:dup_plan]
      @cols = self.options[:cols]
      @defaults = self.options[:defaults] || {}
      @skip_if_all_nils = self.options[:skip_if_all_nils] || []
      @skip_if_any_nils = self.options[:skip_if_any_nils] || []
    end

    def expand_defaults(c)
      r = {}
      @defaults.each do |k, v|
        if v.respond_to? :run
          r[k] = v.run c
        else
          r[k] = v
        end
      end
      r
    end

    def run(c)
      # Check for existing entry
      fval = c.get_val @facade
      return false unless fval.is_a? Hash
      id_vals = fval.slice(*@id_group).compact
      # Expand defaults
      defaults = expand_defaults c
      vals = defaults.merge (@cols ? fval.slice(@cols) : fval)
      # If skip nil found, skip
      if @skip_if_all_nils.present? && vals.slice(*@skip_if_all_nils).compact.empty? ||
          @skip_if_any_nils.present? && vals.slice(*@skip_if_any_nils).compact.size < @skip_if_any_nils.size
        Rails.logger.debug "#{@model.name} operation skipped. Row idx: `#{c.sheet_idx}`. Values are #{vals}"
        return false
      end
      existing = @model.find_by id_vals
      if existing
        # Raise exception if no dup allowed
        case @dup_plan
          when :fail
            # Raise exception if no dup allowed
            dup_error "#{@model.name} id=#{existing.id} exists for id_group values #{id_vals}."
          when :update
            # Update
            existing.update! vals
          when :skip
            # Do nothing if ignoring duplicate
            Rails.logger.debug "#{@model.name} id=#{existing.id} exists for id_group values #{id_vals}. " +
                                  "Row `#{c.sheet_idx}` skipped."
          else
            # Unreachable state
            unreachable_state_error "Unknown dup_plan: `#{@dup_plan}`."
        end
      else
        # Proceed with insertion, if no duplicate exists
        @model.create! vals
      end
      true
    end

    protected
    def dup_error(msg)
      raise except_m::DupError msg
    end
  end
end