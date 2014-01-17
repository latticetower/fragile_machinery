require 'em-websocket'
# websocket server based on simple example from em-websocket page
require File.dirname(__FILE__) + '/console_server.rb'
chat_host = "0.0.0.0"
chat_port = 8080
chat_host = ARGV[0] if ARGV.size > 0
chat_port = ARGV[1].to_i if ARGV.size > 1


@@clients = {}

EM.run {
  EM::WebSocket.run(:host => chat_host, :port => chat_port) do |ws|
    ws.onopen { |handshake|
      puts "Someone opened WebSocket connection"
      @@clients[ws] = EMGameServer.new(ws)
      # EMGameServer::add_connection(ws)
      # Access properties on the EM::WebSocket::Handshake object, e.g.
      # path, query_string, origin, headers

      # Publish message to the client
      ws.send "Welcome, #{@@clients[ws].name}"
    }

    ws.onclose { 
      puts "Connection closed" 
      @@clients[ws].disconnect
      @@clients.delete(ws)
    }

    ws.onmessage { |msg|
      puts "Recieved message: #{msg}"
      @@clients[ws].process_message(msg)
     # @@connections.each do |connection|
      
      # ws.send "#{msg}"
    }
  end
}