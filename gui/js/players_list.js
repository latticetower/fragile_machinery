function updateUserList(users) {
  players_container = document.getElementById('players_list');
  players_container.innerHTML = "";
  var obj  = jQuery.parseJSON( users );
  for (var key in obj) {
    var d = document.createElement("div"); 
    d.id = key;
    d.innerHTML =  "" + obj[key].name;
    if (obj[key].busy == false)
      d.innerHTML  += " <a href='#' onclick=inviteToGame('" + key + "')>Пригласить</a>"; 
    players_container.appendChild(d);
  }
}
 

function initTable() {
  //table_container = document.getElementById("table_container");
  //table_container.innerHTML = "";
}
function UpdateMyBoard(user) {
  console.log(user['prod']);
  $('#player2_prod').html(user.prod);
}

function UpdateEnemyBoard(user) {
}

function redrawTable(data) {
  table_container = document.getElementById("table_container");
  user1 = jQuery.parseJSON(data)[0];
  user2 = jQuery.parseJSON(data)[1];
  if (user1.user_id == currentId) {
    UpdateMyBoard(user1);
    UpdateEnemyBoard(user2);
    return;
  }
  if (user2.user_id == currentId) {
    UpdateMyBoard(user2);
    UpdateEnemyBoard(user1);
    return
  }
  //let's pretend someone else can watch the game
  UpdateMyBoard(user1);
  UpdateEnemyBoard(user2);
}