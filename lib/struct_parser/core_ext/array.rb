class Array
  include StructParser::OperationBody

  ##
  # Run each in sequence and don't stop even after hitting a false
  def run(*args)
    each do |op|
      op.run *args
    end
    true
  end

end