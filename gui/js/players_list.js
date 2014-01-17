var wsUri2 = "ws://127.0.0.1:8081/"; 
var playersListElement;

function initGameGUI() { 
  output = document.getElementById("players_list"); 
  output.innerHTML = "<div id='players'></div>";
  var d = document.createElement("div"); 
  //d.innerHTML = "<input id='ff' type='text' value=''></input>" + 
  //                "<button onclick='sendMessage(ff.value)'>Отправить!</button>"; 
  output.appendChild(d); 
  playersListElement = document.getElementById("players");
  testWebSocket2(); 
}  
function testWebSocket2() { 
  websocket = new WebSocket(wsUri2); 
  websocket.onopen = function(evt) { onOpen2(evt) }; 
  websocket.onclose = function(evt) { onClose2(evt) }; 
  websocket.onmessage = function(evt) { onMessage2(evt) }; 
  websocket.onerror = function(evt) { onError2(evt) }; 
}  
function onOpen2(evt) { 
  writeToScreen2("CONNECTED"); 
  //doSend("WebSocket rocks"); 
}  
function onClose2(evt) { 
  writeToScreen2("DISCONNECTED"); 
}  
function onMessage2(evt) { 
  writeToScreen2('<span style="color: blue;">' + evt.data+'</span>'); 
  //websocket.close(); 
}  
function onError2(evt) { 
  writeToScreen2('<span style="color: red;">ERROR:</span> ' + evt.data); 
}  
function doSend2(message) { 
  //writeToScreen("SENT: " + message);  
  websocket.send(message); 
}
function sendMessage2(value) {
  //output = document.getElementById("chat_container"); 
  doSend2(value);
}
function writeToScreen2(message) { 
  var pre = document.createElement("p"); 
  pre.style.wordWrap = "break-word"; 
  pre.innerHTML = message; 
  playersListElement.appendChild(pre); 
}

window.addEventListener("load", initGameGUI, false);  