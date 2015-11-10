module StructParser
  # Abstract class to be inherited by concrete containers
  # such as SheetCategory, Sheet, Row, Column or Cell
  class Container
    attr_accessor :parent,   # Parent container
                  :children, # Array of child containers
                  :context,  # Context of current container
                  :has_ran,  # Flag, whether current container has already executed
                  :op_squad  # Operation squad for current container

    def initialize(options={})
      self.parent = options[:parent] || nil
      self.context = options[:context] || {}
      self.op_squad = {}.merge(options[:op_squad] || {})
      self.children = []
      parent.children << self if parent
    end

    def dup(parent)
      obj = self.class.new parent: parent
      obj.children = self.children.each do |child|
        child.dup obj
      end
      obj
    end

    ##
    # Main executor
    def run
      # Only run before_children once
      unless has_ran
        before_children
        self.has_ran = true
      end
      # Children always run
      children.map &:run
      # after_children always run
      after_children
      # after_parent for all children
      children.each do |c|
        c.after_parent self
      end
      self
    end

    ##
    # Getter and setter
    def raw
      context[:raw]
    end

    def raw=(v)
      self.context[:raw] = v
    end

    def val
      context[:val]
    end

    def val=(v)
      self.context[:val] = v
    end

    def name
      context[:name]
    end

    def name=(n)
      self.context[:name] = n
    end

    def get_val(facade=[])
      facade = [facade].flatten
      facade << :val
      StructParser::Utils.get_in context, *facade
    end

    def set_val(v, facade=[], k=[])
      facade = [facade].flatten
      facade << :val
      facade += [k].flatten
      StructParser::Utils.assoc_in context, v, *facade
    end

    ##
    # Should only execute once
    def before_children
      run_if_should :before_children
    end

    ##
    # Run as many times as +run+
    def after_children
        run_if_should :after_children
    end

    ##
    # Run after parent operation finishes
    def after_parent(parent)
      run_if_should :after_parent, parent
    end

    def run_if_should(trigger, *args)
      op = op_squad[trigger]
      op.run self, *args unless op.nil?
    end

  end
end
