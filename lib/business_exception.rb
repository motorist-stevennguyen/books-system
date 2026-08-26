class BusinessException < StandardError
  attr_reader :code, :message

  def initialize(err_msg)
    code, message = err_msg.split("|", 2)
    @code = code
    @message = message
    super(message)
  end
end
