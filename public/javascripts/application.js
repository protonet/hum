head(function() {
  var mySound = null;
  var playing = null;

  soundManager.onready(function() {
    $(".track a").click(function(e) {
      if (mySound != null) {
        soundManager.stop('Track ' + playing);
      }

      e.preventDefault();
      id = $(this).attr('data-track-id');
      playing = id
      mySound = soundManager.createSound({
        id: 'Track ' + id,
        url: 'http://node:3340/' + id,
        volume: 50
      });
      mySound.play();
    });
  });
});

