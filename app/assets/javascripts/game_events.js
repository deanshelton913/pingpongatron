$(function(){

  // NOTE:
  // This file is a bit insane... 
  // Many of the things here are bad practice... and i know it. :/
  // This is a hobby project, and my first attempt with web sockets.
  window.GameEvents = {} 
  GameEvents.dispatcher = new WebSocketRails(window.location.href.split("/")[2] + '/websocket');

  // We always send the same thing to the server... Our players id.
  // That, combined with the event we are triggering, is enough context
  // to take action on the state of the game.
  GameEvents.standard_payload = { 'player_id': Number(session.id) }

  // Binding methods. 
  // These are used to attach send/receive events to the dispatcher.
  GameEvents.receive = function (event_name, callback){
    GameEvents.dispatcher.bind(event_name, callback);
  };

  GameEvents.send = function(event_name){
    this.dispatcher.trigger(event_name, this.standard_payload, this.success, this.failure);
  };

  GameEvents.dispatcher.on_open = function(data) {
    console.log('Connection has been established: ', data);
    // You can trigger new server events inside this callback if you wish.
  }

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
    $('body').on('click', target_selector, function(e){
      e.preventDefault();
      GameEvents.send(event_name);
    });
  }

  // HELPERS --------------------------
  // These are just a way of abscracting complexity into
  // a more readable context.
  function game_is_full(data){
    if (data.game_state.players.length === 2){
      return true;
    }
    return false;
  }

  function redirect_to(path){
    window.location = path;
  }

  // RECEIVERS ------------------------
  // These are implimented in specific views that require
  // some action based on a subscribed event.
  // Really, these should go elsewhere... but... meh.
  redirect_to_current_game_when_matched = function(data){
    console.log(data);
    if (game_is_full(data)) {
      redirect_to('/games/current');
    }
  }

  repaint_current_game_screen = function(data){
    console.log(data)
    $.get('/mustache/current_game.mst', function(template) {
      var payload = { 
        'players' : data.game_state.players, 
        'controllable': function(){
          return (this.id == window.session.id ? 'controllable' : '');
        }
      }
      var rendered = Mustache.render(template, payload);
      $('#current_game').html(rendered);
    });
  }
});