var wsUri = "ws://106.187.53.147:8080/"; 
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
  writeToScreen("CONNECTED"); 
  //doSend("WebSocket rocks"); 
}  
function onClose(evt) { 
  writeToScreen("DISCONNECTED"); 
}  
function onMessage(evt) { 
 
  var obj  = JSON.parse(evt.data);

  if (obj.type == 'user_list') {
    updateUserList(obj.data);
    return;
  }
 //writeToScreen('<span style="color: blue;">' + evt.data+'</span>'); 
  if (obj.type == 'message') {
  //alert('got message');
    onNewChatMessage(obj.data);
    return;
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

function onNewChatMessage(data) {
  writeToScreen('<span style="color: black;">' + data+'</span>'); 
}