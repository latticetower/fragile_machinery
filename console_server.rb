#!/usr/bin/env ruby
#
# server_1

require 'rubygems'
require 'eventmachine'
require './lib/game_server.rb'
require './lib/user.rb'


class EMGameServer
  @@game_server = GameServer.new
  @@connections = []
  attr_reader :username
  @connection
  
  def initialize(connection)
    @connection = connection
    EMGameServer.add_connection(connection)
  end
    
  def post_init
    puts "-- someone connected to the echo server!"
    
  end

  def self.add_connection(connection)
    @@connections << connection
  end
    
  def self.remove_connection(connection)
    @@connections.remove(connection)
  end
    
  def self.send_to_all(msg)
    @@connections.each do |connection|
      connection.send %Q{#{msg}}
    end
  end
    
    def process_message msg
      puts "got message: #{msg}"
      case msg
        when /u game/i
          user2 = data.sub("u game ", "").strip
          @@game_server.create_game(username, user2)
          @@connections[user2].send_data "request game with #{username}"
        when /game accepted/
          user2 = data.sub("u game ", "").strip
          @@game_server.game_ready(username, user2)
        when /game rejected/
          @@game_server.game_reject(username, user2)
        when /u list/i
          puts "in ulist handler"
          @connection.send @@game_server.user_list 
        
      end
    end
    
    def receive_data data
      #send_data ">>> you sent: #{data}"
      puts "command recieved: #{data}"
      if data == "u list"
        
      end

      
      if data.index("new user") == 0 
        @username = data.sub("new user ", "").strip
        @@game_server.add_user(username, User.new(@username))
        @@connections[@username] = self
      end
    end
    def unbind
      @@connections.delete(self.username)
      @@game_server.remove_user(username)
      puts "#{self.username} is out"
    end
  end

 # EventMachine::run {
 #   EventMachine::start_server "127.0.0.1", 8081, EchoServer
#    puts 'running echo server on 8081'
#  }