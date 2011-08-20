head(function() {
  var mySound = null;
  var playing = null;
  var numOfTracks = parseInt($('#number-of-tracks .count').text());
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

    // Player Controls
    $("#player .skip-backwards a").click(function() {
      underConstruction();
    });

    $("#player .seek-backwards a").click(function() {
      underConstruction();
    });

    $("#player .play a").click(function() {
      if (mySound == null) {
        nextTrack();
      } else {
        playPauseToggle();
        soundManager.togglePause(playing);
      }
    });

    $("#player .seek-forwrds a").click(function() {
      underConstruction();
    });

    $("#player .skip-forwrds a").click(function() {
      nextTrack();
    });
    // End Player Controls

    $("#player #currently-playing a").click(function() {
      jumpToCurrentlyPlaying();
    });

    $("#player #vol-up a").click(function() {
      newVolume = mySound.volume + 10;
      if (newVolume > 100) newVolume = 100;
      setVolume(newVolume);
    });

    $("#player #vol-down a").click(function() {
      newVolume = mySound.volume - 10;
      if (newVolume < 0) newVolume = 0;
      setVolume(newVolume);
    });
  });

  function setVolume(volumeValue) {
    if (mySound != null) {
      mySound.setVolume(newVolume);
      $("#player #volume-level").text(mySound.volume);
      globalVolume = mySound.volume;
    }
  }

  function playTrack(track_id) {
    soundManager.stopAll();
    $("#player .play a").html("<img alt='play' src='/images/play.png'>");

    $.ajax({
      url: '/track/' + track_id,
      dataType: 'json',
      data: {format: 'js'},
      success: function(trackInfo) {
        playingName = trackInfo['artist'] + ' - ' + trackInfo['title'];
        if (playingName == '') playingName = trackInfo['filename']

        setTrackInfo(trackInfo)

        mySound = soundManager.createSound({
          id: playingName,
          url: getServerUrl() + '/' + track_id,
          volume: globalVolume,
          onjustbeforefinish: nextTrack
        });

        $("#player .play a").html("<img alt='pause' src='/images/pause.png'>");
        $("#player #volume-level").text(mySound.volume);

        jumpToCurrentlyPlaying();
        mySound.play();
      }
    });
  }

  function underConstruction() {
    alert("This doesn't do anything yet. Come back later");
  }

  function setTrackInfo(trackInfo) {
    $("#track-info .artist .name").html(trackInfo['artist']);
    $("#track-info .album .name").html(trackInfo['album']);
    $("#track-info .title .name").html(trackInfo['title']);
    $("#track-info .filename .name").html(trackInfo['filename']);
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
      $("#player .play a").text("<img alt='pause' src='/images/pause.png'>");
    } else {
      $("#player .play a").text("<img alt='play' src='/images/play.png'>");
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

