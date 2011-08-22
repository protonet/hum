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

  $("#search-form input[type='submit']").click(function(e) {
    e.preventDefault();
    $.ajax({
      url: '/search/' + $("#search-form #search").attr('value'),
      success: function(data) {
        $("#search .results").html(data);
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
        mySound.togglePause();
        if (mySound.paused) {
          setPlayState();
        } else {
          setPauseState();
        }
      }
    });

    $("#player .seek-forwrds a").click(function() {
      underConstruction();
    });

    $("#player .skip-forwrds a").click(function() {
      nextTrack();
    });
    // End Player Controls

    $(".track a").live('click', function(e) {
      e.preventDefault();
      playTrack($(this).attr('data-track-id'));
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

        if (trackInfo['artist'] != '' || trackInfo['title'] != '') {
          playing = trackInfo['artist']

          if (playing != '') playing += ' - ';

          playing +=  trackInfo['album']

          if (playing != '') playing += ' - ';

          playing += trackInfo['title'];
        } else {
          playing = trackInfo['filename']
        }

        setTrackInfo(trackInfo)

        mySound = soundManager.createSound({
          id: playing,
          url: getServerUrl() + '/' + track_id,
          volume: globalVolume,
          onjustbeforefinish: nextTrack
          //ondataerror: alert("THERE HAS BEEN A DATA ERROR")
        });

        $("#player .play a").html("<img alt='pause' src='/images/pause.png'>");
        $("#player #volume-level").text(mySound.volume);

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

  function setPlayState() {
    $("#player .play a").html("<img alt='play' src='/images/play.png'>");
  }

  function setPauseState() {
    $("#player .play a").html("<img alt='pause' src='/images/pause.png'>");
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

