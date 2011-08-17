head(function() {
  var mySound = null;
  var playing = null;
  var numOfTracks = $('.track').length;
  var nextTrackIndex = 0;
  var globalVolume = 100;

  soundManager.onready(function() {
    $(".track a").click(function(e) {
      e.preventDefault();

      soundManager.stopAll();
      $("#player .play a").text('Play');
      $(".track").removeClass('playing');

      id = $(this).attr('data-track-id');
      $('#track-' + id).addClass('playing');
      playing = 'Track ' + id
      track_name = $(this).attr('data-track-name')
      server = $("#server-url").text();
      mySound = soundManager.createSound({
        id: playing,
        url: server + '/' + id,
        volume: globalVolume,
        onjustbeforefinish: nextTrack
      });
      $("#player .play a").text('Pause');
      $('#tracks').animate({scrollTop: $(".playing").prop("offsetTop")},'fast');
      $("#player #volume").text(mySound.volume);
      mySound.play();
    });

    $("#player .play a").click(function() {
      playPauseToggle();
      soundManager.togglePause(playing);
    });

    $("#player .prev a").click(function() {
      alert("This doesn't do anything yet. Come back later");
    });

    $("#player .next a").click(function() {
      nextTrack();
    });

    $("#player #vol-up a").click(function() {
      newVolume = mySound.volume + 10;
      if (newVolume > 100) newVolume = 100;
      if (mySound != null) {
        mySound.setVolume(newVolume);
        $("#player #volume").text(mySound.volume);
        globalVolume = mySound.volume;
      }
    });

    $("#player #vol-down a").click(function() {
      newVolume = mySound.volume - 10;
      if (newVolume < 0) newVolume = 0;
      if (mySound != null) {
        mySound.setVolume(newVolume);
        $("#player #volume").text(mySound.volume);
        globalVolume = mySound.volume;
      }
    });

    function nextTrack() {
      if (isRandomPlay()) {
        nextTrackIndex = randomTackNumber();
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

    function randomTackNumber() {
      return Math.floor(Math.random()*numOfTracks);
    }

    function isRandomPlay() {
      if ($("#player .random input:checked").length >= 1) {
        return true;
      } else {
        return false;
      }
    }

  });
});

