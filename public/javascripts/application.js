head(function() {
  var mySound = null;
  var playing = null;
  var numOfTracks = $('.track').length;

  soundManager.onready(function() {
    $(".track a").click(function(e) {
      soundManager.stopAll();
      $("#player .play a").text('Play');

      e.preventDefault();
      id = $(this).attr('data-track-id');
      playing = 'Track ' + id
      track_name = $(this).attr('data-track-name')
      server = $("#server-url").text();
      mySound = soundManager.createSound({
        id: playing,
        url: server + '/' + id,
        volume: 50,
        onjustbeforefinish: nextTrack
      });
      $("#player .play a").text('Pause');
      mySound.play();
    });

    $("#player .play a").click(function() {
      playPauseToggle();
      soundManager.togglePause(playing);
    });

    $("#player .next a").click(function() {
      nextTrack();
    });

    function nextTrack() {
      nextTrackObj = Math.floor(Math.random()*numOfTracks)
      $('.track').slice(nextTrackObj,(nextTrackObj+1)).find('.number a').click();
    }

    function playPauseToggle() {
      if ($("#player .play a").text() == 'Play') {
        $("#player .play a").text('Pause');
      } else {
        $("#player .play a").text('Play');
      }
    }

  });
});

