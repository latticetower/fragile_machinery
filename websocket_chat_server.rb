require 'em-websocket'
# websocket server based on simple example from em-websocket page

chat_host = "0.0.0.0"
chat_port = 8080
chat_host = ARGV[0] if ARGV.size > 0
chat_port = ARGV[1].to_i if ARGV.size > 1

@@connections = []

EM.run {
  EM::WebSocket.run(:host => chat_host, :port => chat_port) do |ws|
    ws.onopen { |handshake|
      puts "Someone opened WebSocket connection"
      @@connections << ws
      # Access properties on the EM::WebSocket::Handshake object, e.g.
      # path, query_string, origin, headers

      # Publish message to the client
      ws.send "Hello Client, you connected to #{handshake.path}"
    }

    ws.onclose { puts "Connection closed" }

    ws.onmessage { |msg|
      puts "Recieved message: #{msg}"
      @@connections.each do |connection|
        connection.send "#{msg}"
      end
      # ws.send "#{msg}"
    }
  end
}