$(function(){
    $('.search').keyup(function(e) {
        clearTimeout($.data(this, 'timer'));
        if (e.keyCode == 13)
          search(true);
        else
          $(this).data('timer', setTimeout(search, 500));
    });

    function render_players_results(data, target) {
      $.get('/mustache/players_search_results.mst', function(template) {
        var rendered = Mustache.render(template, {"players": data});
        target.html(rendered);
        target.show()

         // NO DATA BINDING!?  D:
        $('#results .player').click(function(e){
            var name = $(this).find('.name').html();
            var player_id = $(this).attr('id');
            $('#search_area input').val(name);
            $('input#player_id').val(player_id);
            $('#results').hide();
            $('form#new_session').submit();
        });
      });
    }

    function search(force) {
        var existingString = $(".search").val();
        var resource_to_search = $('.search').data('resource')
        if (!force && existingString.length < 3) return; //wasn't enter, not > 2 char
        $.get('/search/' + resource_to_search +'?q=' + existingString, function(data) {
            render_players_results(data, $('#results'));
        });
    };

});