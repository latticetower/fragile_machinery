require 'rubygems'
require 'daemons'

Daemons.run(File.dirname(__FILE__) + '/websocket_chat_server.rb')