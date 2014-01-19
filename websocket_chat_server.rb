require 'em-websocket'
# websocket server based on simple example from em-websocket page
require File.dirname(__FILE__) + '/console_server.rb'
chat_host = "0.0.0.0"
chat_port = 8080
chat_host = ARGV[0] if ARGV.size > 0
chat_port = ARGV[1].to_i if ARGV.size > 1


@@clients = {}
# we need to create channel for broadcasted messages, when we create task which sends data via it

begin
  EM.run {
    EM::WebSocket.run(:host => chat_host, :port => chat_port) do |ws|
      
      ws.onopen { |handshake|
        puts "Someone opened WebSocket connection"
        @@clients[ws] = EMGameServer.new(ws)
        @@clients[ws].subscribe
        EMGameServer.send_user_list_to_all 
        # Publish message to the client
       
       
      }

      ws.onclose { 
        puts "Connection closed" 
        @@clients[ws].unsubscribe
        @@clients[ws].disconnect
        @@clients.delete(ws)
        EMGameServer.send_user_list_to_all 
      }

      ws.onmessage { |msg|
        puts "Recieved message: #{msg}"
        @@clients[ws].process_message(msg)
      }
    end
    EM::add_periodic_timer(5) {
      # EMGameServer.send_user_list_to_all 
    }
  }
rescue Exception => e
  f = File.new('errors.txt', 'a')
  f.puts e
  f.puts e.backtrace.first(5).join("\n") 
  puts e
  puts e.backtrace.first(5).join("\n")  
  f.close
end