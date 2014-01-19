function updateUserList(users) {
  var players_container = document.getElementById('players_list');
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
  $('#player2_prod').html(user.prod);
  $('#player2_supply').html(user.supply);
}

function UpdateEnemyBoard(user) {
  $('#player1_prod').html(user.prod);
  $('#player1_supply').html(user.supply);
}

function redrawTable(data) {
  table_container = document.getElementById("table_container");
  var user1 = jQuery.parseJSON(data)[0];
  var user2 = jQuery.parseJSON(data)[1];
  if (user1.user_id == currentId) {
    (user1);
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

function redrawHand(data) {
  $("#player2_hand").empty();
  data.forEach(function(card){
    var html = renderCard(card);
    $("#player2_hand").append(html);
  });
}

function renderCard(card) {
  var template = $("#template-card").html();
  return Mustache.render(template, card);
}