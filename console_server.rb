#!/usr/bin/env ruby
#
# server_1

require 'rubygems'
require 'eventmachine'
require './lib/game_server.rb'
require './lib/user.rb'


class EMGameServer
  @@game_server = GameServer.new
  @@connections = {}
  attr_reader :user_id
  attr_reader :name
  @connection
  
  def initialize(connection)
    @connection = connection
    @user_id = "user_" + (@@connections.size + 1).to_s
    @name = @user_id
    @@game_server.add_user(@user_id, User.new(@user_id))
    @@connections[connection] = self
  end
    
  def post_init
    puts "-- someone connected to the echo server!"
    
  end


  def new_user
    @user_id = data.sub("new user ", "").strip
    
  end
  

    
  def self.remove_connection(connection)
    @@connections.delete(connection)
  end
  
  def send msg
    @connection.send msg
  end
  
  def self.send_to_all(msg)
    @@connections.each do |k, v|
      v.send msg
    end
  end
    
    def process_message msg
      puts "got message: #{msg}"
      case msg
        when /u list/i
          puts "in ulist handler"
          send_user_list
        when /u rename [A-Za-z0-9]+/
          puts "renaming"
          name = msg.sub("u rename ", "").sub(/[^A-Za-z0-9]/, '')
          rename_user(name) if name.size > 0
        when /m /
          puts "broadcast message"
          EMGameServer.send_to_all(msg.sub("m ", "#{@name}: "))
        
        when /g with user_[0-9]+/i
          user_id2 = data.sub("g with ", "").sub(/[^A-Za-z0-9_]/).strip
          puts "#{user_id} sent game request to #{user_id2}"
          send_game_request(user_id2)
        when /game accepted/
          user_id2 = data.sub("u game ", "").sub(/[^A-Za-z0-9_]/).strip
          
          @@game_server.game_ready(user_id, user_id2)
        when /game rejected/
          @@game_server.game_reject(user_id, user2)
      end
    end
    # service methods
    def send_user_list
      @connection.send @@game_server.user_list(:json) 
    end
    
    def rename_user(name)
      @@game_server.rename(@user_id, name)
      @name = name
    end
    
    def send_game_request(user_id)
      @@game_server.create_game(user_id, user2)
      @@connections[user_id2].send_data "#{user_id} requested game"
      #TODO: need to send json request
      # also user_id sends request - it means he accepts the game
    end
    # end of service methods

    def receive_data data
      #send_data ">>> you sent: #{data}"
      puts "command recieved: #{data}"
      if data == "u list"
        
      end

      
      if data.index("new user") == 0 
        @user_id = data.sub("new user ", "").strip
        @@game_server.add_user(user_id, User.new(@username))
        @@connections[@user_id] = self
      end
    end
    def unbind
      @@connections.delete(self.user_id)
      @@game_server.remove_user(user_id)
      puts "#{self.user_id} is out"
    end
  end

 # EventMachine::run {
 #   EventMachine::start_server "127.0.0.1", 8081, EchoServer
#    puts 'running echo server on 8081'
#  }