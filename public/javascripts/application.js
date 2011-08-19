head(function() {
  var mySound = null;
  var playing = null;
  var numOfTracks = $('.track').length;
  var nextTrackIndex = 0;
  var globalVolume = 100;
  var mySound = null;

  $("#server-form input[type='submit']").click(function(e) {
    e.preventDefault();
    $.ajax({
      url: '/server_url',
      data: { server_url: getServerUrl() },
      success: function(data) {
        setServerUrl(data);
        alert("Saved! " + data);
      }
    });
  });

  soundManager.onready(function() {
    $("#player .play a").click(function() {
      if (mySound == null) {
        nextTrack();
      } else {
        playPauseToggle();
        soundManager.togglePause(playing);
      }
    });

    $("#player .prev a").click(function() {
      alert("This doesn't do anything yet. Come back later");
    });

    $("#player .next a").click(function() {
      nextTrack();
    });

    $("#player #currently-playing a").click(function() {
      jumpToCurrentlyPlaying();
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
  });

  function playTrack(track_id) {
    soundManager.stopAll();
    $("#player .play a").text('Play');

    var trackInfo = null;

    $.ajax({
      url: '/show',
      data: { id: track_id },
      success: function(data) {
        trackInfo = data;
      }
    });

    playing = trackInfo['name']

    mySound = soundManager.createSound({
      id: playing,
      url: getServerUrl() + '/' + id,
      volume: globalVolume,
      onjustbeforefinish: nextTrack
    });

    $("#player .play a").text('Pause');
    $("#player #volume").text(mySound.volume);

    jumpToCurrentlyPlaying();
    mySound.play();
  }

  function nextTrack() {
    if (isRandomPlay()) {
      nextTrackIndex = randomTackNumber();
    } else {
      nextTrackIndex = nextTrackIndex + 1
    }

    playTrack(nextTrackIndex);
  }

  function jumpToCurrentlyPlaying() {
    $('#tracks').animate({scrollTop: $(".playing").prop("offsetTop")},'fast');
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

  function getServerUrl() {
    return $("#server-form #server_url").attr("value");
  }

  function setServerUrl(data) {
    $("#server-form #server_url").attr("value", data)
  }
});

