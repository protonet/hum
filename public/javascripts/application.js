var timmer = null;
var mySound = null;
var playing = null;
var numOfTracks = parseInt($('#number-of-tracks .count').text());
var nextTrackIndex = 0;
var globalVolume = 100;

function displayCurrentTime() {
  if (mySound != null && timmer != null) {
    base_unit = (mySound.position / 1000);
    minutes = Math.floor((base_unit / 60))
    seconds = Math.round(base_unit % 60);
    current_time = minutes + "." + seconds

    overall_time = "";

    if (mySound.loaded) {
      base_unit = (mySound.duration / 1000);
      minutes = Math.floor((base_unit / 60))
      seconds = Math.round(base_unit % 60);

      overall_time = " / " + minutes + "." + seconds
    }

    $("#player #time").text(current_time + overall_time);
  }

  timmer = setTimeout("displayCurrentTime()",1000);
}

head(function() {

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
      url: '/tracks/search?term=' + $("#search-form #search").attr('value'),
      success: function(data) {
        $("#search .results").html(data);
      }
    });
  });

  soundManager.onerror = function(status) {
    alert("Hey. Something went wrong. Flash didn't load. " + status.type);
  };

  soundManager.onready(function() {

    // Player Controls
    $("#player .skip-backwards a").click(function() {
      underConstruction();
    });

    $("#player .seek-backwards a").click(function() {
      if (mySound != null && mySound.loaded) {
        newValue = mySound.position - 10000
        if (newValue < 0) newValue = 0;
        mySound.setPosition(newValue);
      }
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

    $("#player .stop a").click(function() {
      if (mySound != null) {
        mySound.destruct();
      }
    });

    $("#player .seek-forwrds a").click(function() {
      if (mySound != null && mySound.loaded) {
        newValue = mySound.position + 10000
        if (newValue > mySound.duration) newValue = mySound.duration - 10000;
        mySound.setPosition(newValue);
      }
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

  // TODO: Load the queue
  function loadQueue() {
  }

  // TODO load the list
  function loadList() {
  }

  function setVolume(volumeValue) {
    if (mySound != null) {
      mySound.setVolume(newVolume);
      $("#player #volume-level").text(mySound.volume);
      globalVolume = mySound.volume;
    }
  }

  function playTrack(track_id) {
    if (mySound != null) {
      // TODO: Add the current song to the list if the song
      // has played more than 20 seconds
      mySound.destruct();
    }
    if (timmer != null) clearTimeout(timmer);

    $("#player .play a").html("<img alt='play' src='/images/play.png'>");

    $.ajax({
      url: '/tracks/' + track_id,
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

        extraInstruction = serveViaNginx() ? '?nginx=true' : '';

        mySound = soundManager.createSound({
          id: playing,
          url: getServerUrl() + '/' + track_id + extraInstruction,
          volume: globalVolume,
          onfinish: nextTrack
          //ondataerror: alert("THERE HAS BEEN A DATA ERROR")
        });

        $("#player .play a").html("<img alt='pause' src='/images/pause.png'>");
        $("#player #volume-level").text(mySound.volume);

        mySound.play();

        timmer = setTimeout("displayCurrentTime()",1000);
      }
    });
  }

  function underConstruction() {
    if (mySound != null) {
      if ((mySound.position / 1000) >= 5) {
        mySound.setPosition(0)
      } else {
        alert("This will jump to the previous track when I have implemented it");
      }
    }
  }

  function setTrackInfo(trackInfo) {
    $("#track-info .track-num .name").html(trackInfo['track']);
    $("#track-info .artist .name").html(trackInfo['artist']);
    $("#track-info .album .name").html(trackInfo['album']);
    $("#track-info .title .name").html(trackInfo['title']);
    $("#track-info .genres .name").html(trackInfo['genres']);
    $("#track-info .filename .name").html(trackInfo['filename']);
  }

  function nextTrack() {
    // TODO: Check if there is something in the queue
    if (false) {

    } else if (isRandomPlay()) {
      nextTrackIndex = randomTackNumber();
    } else {
      nextTrackIndex = nextTrackIndex + 1
    }

    $.ajax({
      url: '/track/to_id/' + nextTrackIndex,
      dataType: 'json',
      data: {format: 'js'},
      success: function(trackHash) {
        playTrack(trackHash['id']);
      }
    });
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

  function serveViaNginx() {
    return checkBoxChecked("#nginx input:checked");
  }

  function isRandomPlay() {
    return checkBoxChecked("#player .random input:checked");
  }

  function checkBoxChecked(selector) {
    if ($(selector).length >= 1) {
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

