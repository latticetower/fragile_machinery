﻿#!/usr/bin/env ruby
#
# server_1
require 'json'
require 'rubygems'
require 'eventmachine'
require File.dirname(__FILE__) + '/lib/game_server.rb'
require File.dirname(__FILE__) + '/lib/user.rb'


class EMGameServer
  @@game_server = GameServer.new
  @@connections = {}
  attr_reader :user_id
  attr_reader :name
  @connection
  @@max_users = 0
  @@game_channels = []
  @game_channel = nil
  @game_channel_sid
  
  def set_game_channel(channel)
    if channel.nil?
      @game_channel.unsubscribe(@game_channel_sid) unless @game_channel.nil
    else
      @game_channel_sid = channel.subscribe{|msg| @connection.send msg }
    end
    @game_channel = channel
  end
  
  def send_to_game_channel(msg)
    unless @game_channel.nil?
      @game_channel.push msg
    end    
  end
  # broadcast channels & stuff
  # chat channel
  def self.chat_channel
    @@chat_channel ||= EM::Channel.new
  end
  # user_list channel
  def self.user_list_channel
    @@users_channel ||= EM::Channel.new
  end
  # end of broadcast channels& stuff
  def initialize(connection)
    @@max_users += 1
    @connection = connection
    @user_id = "user_" + @@max_users.to_s
    
    @name = @user_id
    @@game_server.add_user(@user_id, User.new(@user_id))
    @@connections[@user_id] = self  
    
    connection.send EMGameServer.get_chat_message("Привет, #{name}! Можешь переименоваться на свое усмотрение и пригласить кого-нибудь поиграть.")
    message = {'type' => 'info', 'user_id' => @user_id}.to_json
    connection.send message
    
    # send user list to newly connected user
    user_list_with_params =  {
      'data' => @@game_server.user_list(:hash),
      'type' => 'user_list'
    }.to_json
    connection.send user_list_with_params
    
  end
  
  def subscribe
    @chat_sid = EMGameServer.chat_channel.subscribe{|msg| @connection.send msg }
    @users_sid = EMGameServer.user_list_channel.subscribe{|msg| @connection.send msg}
  end
  
  def unsubscribe
    EMGameServer.chat_channel.unsubscribe(@chat_sid)
    EMGameServer.user_list_channel.unsubscribe(@users_sid)
  end
  
  @user_list_changed_flag = false
  def self.send_user_list_to_all(arg = :actual_call)
    if arg == :data_changed
      @user_list_changed_flag = true
      return 
    end
    return unless @user_list_changed_flag
    
    user_list_with_params =  {
      'data' => @@game_server.user_list(:hash),
      'type' => 'user_list'
    }.to_json
    EMGameServer.user_list_channel.push user_list_with_params
    @user_list_changed_flag = true
  end

  def post_init
    puts "-- someone connected to the echo server!"
  end

  def new_user
    @user_id = data.sub("new user ", "").strip
    
  end
  
  def disconnect
    @@game_server.disconnect(@user_id)
    @@connections.delete(@user_id)
  end
  
  def send msg
    @connection.send msg
  end
  
  def self.send_to_all(msg)
    @@connections.each do |k, v|
      v.send msg
    end
  end
  
  def self.get_chat_message msg
    {'type' => 'message', 'data' => msg}.to_json
  end
    
  def process_message msg
    puts "got message: #{msg}"
    case msg
      when /u list/i
        puts "in ulist handler"
        send_user_list
      when /u rename [A-Za-zА-Яа-я0-9]+/
        puts "renaming"
        name = msg.sub("u rename ", "").gsub(/[^A-Za-z0-9А-Яа-я]/, '')
        puts msg + ' - ' + name
        rename_user(name) if name.size > 0
      when /m /
        puts "broadcast message"
        message = msg.sub("m ", "").gsub(/[<>"']/, '')
        EMGameServer.chat_channel.push EMGameServer.get_chat_message("#{@name}: #{message}") if message.size > 0
      #game commands
      when /g with user_[0-9]+/i
        user_id2 = msg.sub("g with ", "").gsub(/[^A-Za-z0-9_]/, '').strip
        puts "#{user_id} sent game request to #{user_id2}"
        send_game_request(user_id2)
      when /g accept user_[0-9]+/
      
        user_id2 = msg.sub("g accept ", "").gsub(/[^A-Za-z0-9_]/, '').strip
        puts "#{user_id} accepted request from #{user_id2}"
        start_new_game(user_id2)
      when /g reject user_[0-9]+/
        user_id2 = msg.sub("g reject ", "").gsub(/[^A-Za-z0-9_]/, '').strip
        puts "#{user_id2} rejected request from #{user_id}"
        @@game_server.game_reject(user_id, user_id2)
        
      when /g hand/
        send_hand
      when /g state/
        send_game_state(@connection)
      when /g put [0-9]+/
        card_id = msg.sub("g put ", "").gsub(/[^0-9]/, '').strip
        put_user_card_to_board(card_id)
      when /g target [0-9]+/
        # not implemented. sets card target
      when /g next/
        send_next_move
      when /g giveup/
        send_giveup
    end
  end
  
  # service methods
  def start_new_game(user_id2)
    channel = EM::Channel.new
    @@game_channels << channel
    @@connections[user_id].set_game_channel(channel) 
    @@connections[user_id2].set_game_channel(channel)
    channel.push EMGameServer.get_chat_message('game started')
    start_message = {'type' => 'state', 'data' => 'game_started'}.to_json
    channel.push start_message
    
    @@game_server.game_ready(user_id, user_id2) do |game|
      game.on_game_state_changed do 
        puts "on game state changed in console server"
        changes = {'type' => 'table_state', 'data' => game.to_json }.to_json #TODO: change event type
        channel.push changes
        
        # send hands separately
        @@connections[user_id].send_hand
        @@connections[user_id2].send_hand
      end
    end
    
  end
  
  def put_user_card_to_board(card_id)
    # to be implemented
  end
  
  def send_next_move
    # to be implemented
  end
  
  def send_giveup
    # to be implemented
  end
  
  def send_user_list
    @connection.send @@game_server.user_list(:json) 
  end
    
  def rename_user(name)
    @@game_server.rename(@user_id, name)
    @name = name
    EMGameServer.send_user_list_to_all(:data_changed)
  end
  
  def send_game_request(user_id2)
    return unless @@connections.has_key? user_id2
    @@game_server.create_game(@user_id, user_id2)
    message = {'type' => 'invite', 'name' => @name, 'user_id' => user_id}.to_json
    @@connections[user_id2].send message
    EMGameServer.get_chat_message("#{user_id} requested game " + 
        "<a href='#' onclick='sendAccept(\"#{user_id}\")'>accept</a>" + 
        " or <a href='#' onclick='sendDecline(\"#{user_id}\")'>decline</a>")
    # TODO: need to send json request
    # also user_id sends request - it means he accepts the game
  end
  
  #method sends to user his cards in hand descriptions in json
  def send_hand
    hand = @@game_server.get_user_hand(user_id)
    puts hand.inspect
    payload = { 'type' => 'hand', 'data' => hand.map{ |c| c.to_hash } }.to_json
    @connection.send payload
  end
  
  def send_game_state(connection)
    puts game.to_json
    game = @@game_server.game_by_player(user_id)
    connection.send game.to_json
  end
  # end of service methods
  
end

 # EventMachine::run {
 #   EventMachine::start_server "127.0.0.1", 8081, EchoServer
#    puts 'running echo server on 8081'
#  }