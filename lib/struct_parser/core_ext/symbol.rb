class Symbol
  include StructParser::OperationBody

  def run(c)
    c.send to_s
  end

end