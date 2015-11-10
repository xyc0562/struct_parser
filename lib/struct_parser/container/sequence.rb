module StructParser
  class Container::Sequence < Container
    attr_accessor :idx
    def initialize(options={})
      self.idx = options.delete :idx
      super options
    end
  end
end
