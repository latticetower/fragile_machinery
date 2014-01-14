class User
  attr_accessor :username
  attr_reader :is_busy

  def initialize
  end
  
  def busy?
    is_busy
  end
  
end