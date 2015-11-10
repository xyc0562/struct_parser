class Proc
  include StructParser::OperationBody

  def run(*args)
    call *args
  end
end
