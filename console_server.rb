#!/usr/bin/env ruby
#
# server_1

require 'rubygems'
require 'eventmachine'
require './lib/game_server.rb'
require './lib/user.rb'



  module EchoServer
    @@game_server = GameServer.new
    @@connections = {}
    def post_init
      puts "-- someone connected to the echo server!"
      
    end

    def receive_data data
      #send_data ">>> you sent: #{data}"
      puts "got #{data}"
      if data == "u list"
        send_data @@game_server.user_list
      end
      
      if data.index("new user") == 0 
        username = data.sub("new user ", "").strip
        @@game_server.add_user(username, User.new(username))
        @@connections[username] = self
      end
    end
  end

  EventMachine::run {
    EventMachine::start_server "127.0.0.1", 8081, EchoServer
    puts 'running echo server on 8081'
  }