head(function() {
  var mySound = null;
  var playing = null;
  var numOfTracks = $('.track').length;
  var nextTrackIndex = 0;

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
      $('#tracks').animate({scrollTop: $("#track-" + id).offset().top},'fast');
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
      if ($("#player .random input:checked").length >= 1) {
        nextTrackIndex = Math.floor(Math.random()*numOfTracks);
      } else {
        nextTrackIndex = nextTrackIndex + 1
      }

      $('.track').slice(nextTrackIndex,(nextTrackIndex+1)).find('.number a').click();
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

