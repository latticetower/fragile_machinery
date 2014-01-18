module GameCallbacks
  @@game_callbacks = {}
  @@game_params = {}
  
  def game_start_callback(first_player, second_player)
    if @@game_callbacks.has_key? :game_start
      puts "game_callbacks"
      players = [first_player, second_player] 
      if @@game_params.has_key? :game_start
        players = @@game_params[:game_start].map do |user_id| 
          (first_player.name == user_id ? first_player : (second_player.name == user_id ? second_player : nil)) 
        end
      end
      @@game_callbacks[:game_start].call(*players)
    end
  end
  
  def game_end_callback
    @@game_callbacks[:game_end].call if @@game_callbacks.has_key? :game_end
  end
  
  def game_state_changed_callback
    @@game_callbacks[:game_state_changed].call if @@game_callbacks.has_key? :game_state_changed
  end
  
  def on_game_start(user_id1, user_id2, &block)
    @@game_callbacks[:game_start] = block
    @@game_params[:game_start] = [user_id1, user_id2]
  end
  
  def on_game_end(&block)
    @@game_callbacks[:game_end] = block
  end
  
  def on_game_state_changed(&block)
    @@game_callbacks[:game_state_changed] = block
  end
  #
  # end of callbacks
  


end