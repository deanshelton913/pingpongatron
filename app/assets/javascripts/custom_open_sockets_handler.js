$(function(){

  window.GameEvents = {}
  GameEvents.standard_payload = { 'player_id': Number(session.id) }
  GameEvents.dispatcher = new WebSocketRails('localhost:3000/websocket');

  // Binding methods. 
  // These are used to attach events to the dispatcher.
  GameEvents.receive = function (event_name, callback){
    GameEvents.dispatcher.bind(event_name, callback);
  };
  GameEvents.send = function(event_name){
    this.dispatcher.trigger(event_name, this.standard_payload, this.success, this.failure);
  };
  GameEvents.success = function(response) {
    console.log('-------------------');
    console.log("Wow it worked: ");
    console.log(response);
    console.log('-------------------');
  }

  GameEvents.failure = function(response) {
    console.log('-------------------');
    console.log("That just totally failed: ");
    console.log(response);
    console.log('-------------------');
  }
  GameEvents.bind_click_send_event = function(target_selector, event_name){
    $(target_selector).click(function(e){
      e.preventDefault();
      GameEvents.send(event_name);
    });
  }

  // HELPERS
  function game_is_full(data){
    if (data.game_state.players.length === 2){
      return true;
    }
    return false;
  }

  function redirect_to(path){
    window.location = path;
  }

  // IMPLEMENTATION

  // Exmaple of an implimentation to be used by a single rails view.
  // GameEvents.receive('game_state_change', function(data){
  //   //...do stuff
  // });
  // GameEvents.send('do_stuff');

  // Receivers
  redirect_to_current_game_when_matched = function(data){
    console.log(data)
    if (game_is_full(data)) {
      redirect_to('/games/current');
    }
  }

  repaint_current_game_screen = function(data){
    console.log(data)
    $.get('/mustache/current_game.mst', function(template) {
      var rendered = Mustache.render(template, { 'players' : data.game_state.players });
      $('#current_game').html(rendered);
    });
  }
});