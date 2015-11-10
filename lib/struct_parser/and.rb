module StructParser
  class And < Operation
    attr_accessor :ops

    def initialize(*ops)
      super ops.extract_options!
      self.ops = ops
    end

    def run(*args)
      ops.each do |op|
        return false unless op.run *args
      end
      true
    end
  end
end
