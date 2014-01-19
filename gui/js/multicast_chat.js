//var wsUri = "ws://106.187.53.147:8080/"; 
var wsUri = "ws://127.0.0.1:8080/"; 
var currentId = "";//влияет только на отрисовку стола
var chatOutputElement;

function initChat() { 
  output = document.getElementById("chat_container"); 
  output.innerHTML = "<div id='chat_output'></div>";
  var d = document.createElement("div"); 
  d.innerHTML = "<input id='id_chat_input' type='text' value=''></input>" + 
                  "<button onclick='sendMessage(id_chat_input.value)'>Отправить!</button>"; 
  output.appendChild(d); 
  chatOutputElement = document.getElementById("chat_output");
  testWebSocket(); 
}  

function testWebSocket() { 
  websocket = new WebSocket(wsUri); 
  websocket.onopen = function(evt) { onOpen(evt) }; 
  websocket.onclose = function(evt) { onClose(evt) }; 
  websocket.onmessage = function(evt) { onMessage(evt) }; 
  websocket.onerror = function(evt) { onError(evt) }; 
}  
function onOpen(evt) { 
  updateStatus("CONNECTED");  
  //doSend("WebSocket rocks"); 
}  
function onClose(evt) { 
  updateStatus("DISCONNECTED"); 
}  
function onMessage(evt) { 
 
  var obj  = JSON.parse(evt.data);
  console.log(obj);
  
  if (obj.type == 'user_list') {
    updateUserList(obj.data);
    return;
  }
 //writeToScreen('<span style="color: blue;">' + evt.data+'</span>'); 
  else if (obj.type == 'message') {
  //alert('got message');
    onNewChatMessage(obj.data);
    return;
  }
  else if (obj.type == 'state') {
    if (obj.data == 'game_started') {
      initTable();
    }
  }
  else if (obj.type == 'table_state') {
    redrawTable(obj.data);
  }
  
  else if (obj.type == 'hand') {
    redrawHand(obj.data);
  }
  else if (obj.type == 'invite') {
    if (obj.user_id) {
      msg = "Игрок " + obj.name + " запросил игру, <a href='#' onclick='sendAccept(\"" + obj.user_id + "\")'>принять</a>" + 
          " или <a href='#' onclick='sendDecline(\"" + obj.user_id + "\")'>отказать</a>?";
      
      onNewChatMessage(msg, "color: blue;");
    }    
  }
  
  else if (obj.type == 'info') {
    if (obj.user_id)
      currentId = obj.user_id;
  }
  
  //websocket.close(); 
}

function onError(evt) { 
  writeToScreen('<span style="color: red;">ERROR:</span> ' + evt.data); 
}  
function doSend(message) { 
  //writeToScreen("SENT: " + message);  
  websocket.send(message); 
}
function sendMessage(value) {
  //output = document.getElementById("chat_container"); 
  doSend("m " + value);
}
function writeToScreen(message) { 
  var pre = document.createElement("p"); 
  pre.style.wordWrap = "break-word"; 
  pre.innerHTML = message; 
  chatOutputElement.appendChild(pre); 
  $("#chat_output").scrollTop($("#chat_output").height());
}

window.addEventListener("load", initChat, false);  

function sendAccept(user_id) {
  doSend("g accept " + user_id);
}
function sendDecline(user_id) {
doSend("g reject " + user_id);
}

function sendRenameCommand(newname) {
  doSend("u rename " + newname);
}
function inviteToGame(user_id) {
  doSend("g with " + user_id);
}

function sendGetMyHand() {
  doSend("g hand " + user_id);
}

function onNewChatMessage(data, style) {
  if (style == "")
    writeToScreen('<span style="color: black;">' + data + '</span>'); 
  else 
      writeToScreen('<span style="' + style + '">' + data + '</span>'); 
}