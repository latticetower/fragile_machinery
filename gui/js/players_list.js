function updateUserList(users) {
  players_container = document.getElementById('players_list');
  players_container.innerHTML = "";
  var obj  = jQuery.parseJSON( users );
  for (var key in obj) {
    users[key];
     var d = document.createElement("div"); 
     d.id = key;
     d.innerHTML =  "" + obj[key].name; 
   players_container.appendChild(d);
}
 

}