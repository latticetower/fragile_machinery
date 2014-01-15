class User
  attr_accessor :name
  attr_reader :is_busy

  def initialize(name)
    @name = name
  end
  
  def busy?
    is_busy
  end
  
end