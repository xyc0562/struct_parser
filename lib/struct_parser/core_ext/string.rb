class String
  include StructParser::OperationBody

  def run(c)
    eval "def _run(c)
            #{self}
          end"
    _run c
  end

end
