Design restrictions in version 0.1:
-----------------------------------
 - deck is the same for all users, it is loaded from file with simple dsl
 - initially, no database is used for storing game state and players achievements
 
Dependencies
------------
- eventmachine
- state_machine

Dependencies Installation
-------------------------
Currently app is build on top of ruby 1.9.3 and rubygems (although all packets are installed via bundler, which can be installed by instructions given at http://bundler.io/).

After installing bundler, simply run command

```
bundle install
```
This command will install all dependencies.

After it, run this command to start server in attached mode:
```
ruby websocket_chat_server.rb
```
If you want to start server in detached mode (detached mode works only in linux-based systems), run this instead:
```
ruby demonized_server.rb
```
Now you can open url http://0.0.0.0:8080 in your webkit-based browser and see what it looks like.

Additional information
----------------------
Basic description (in russian) with state diagrams can be found here: 

http://latticetower.github.io/fragile_machinery/docs/index.html
