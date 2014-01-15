=begin
This script connects to server and operates with current user commands.
user can print command in console
only english in chat is supported in initial commit
=end
require 'rubygems'
require 'eventmachine' # need this for communications with server side

class Echo < EM::Connection
  @@name
  attr_reader :queue

  def initialize(q)
    @queue = q

    cb = Proc.new do |msg|
      send_data(msg)
      q.pop &cb
    end

    q.pop &cb
  end
  def self.set_name(name)
    @@name = name
  end
  def post_init
    send_data("new user #{@@name}") unless @@name.nil?
  end

  def receive_data(data)
    puts data
  end
end

class ConsoleCmdInputHandler < EM::Connection
  include EM::Protocols::LineText2
  
  attr_reader :queue

  def initialize(q)
    @queue = q
  end
  
  # gets user input from EventMachine and process it
  def receive_line data
    # check if user asks help, call help,
    # or other commands. also check for params
    puts "I received the following data from the keyboard: #{data}"
    if data == "help"
      help
      return
    end
    
    @queue.push(data)
  end
  
  # method gets called when player asks for help functionality
  def help
    puts "_____________________________________",
         "Available commands:",
         " m <message> - chat with all players",
         # " m /t <player_name> <message> - chat with specified player" #currently not supported
         " u list - print all users in game with their states (busy or not)",
         " u game <username> - ask for game session with user <username>",
         "In game mode:", #i'll write them later
         " my hand - gets cards list (in hand)",
         " show board - shows my board and opponent's board",
         " move <card number> - puts card to board"
         "------------------------------------"
  end
end
Echo.set_name(ARGV[0])
EM.run {
  q = EM::Queue.new
  EM.connect('127.0.0.1', 8081, Echo, q)
  EM.open_keyboard(ConsoleCmdInputHandler, q)
  
}