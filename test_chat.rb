require 'eventmachine'

# simple server module to handle incoming requests and broadcast them
module MulticastRoom
  @@connections = []
  
  def post_init
    @@connections << self
    puts "new connection #{self}"
  end
  def receive_data data
    puts "got data: #{data}"
    @@connections.each{ |connection| connection.send_data data }
  end
  
  def unbind
    @@connections.delete(self)
  end
  
end

EventMachine::run {
  host, port = "0.0.0.0", 8080
  EventMachine::start_server host, port, MulticastRoom
  puts "Listening #{host}:#{port}..."
}