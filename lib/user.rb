class User
  attr_accessor :username
  attr_reader :is_busy

  def initialize(name)
    @username = name
  end
  
  def busy?
    is_busy
  end
  
end