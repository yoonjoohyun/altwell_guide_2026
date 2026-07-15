<script>
/* Player Controls - bridges UI to SceneRunner */
function mediaSceneIndex(){
  var idx = SceneRunner.getCurrentIndex();
  return idx < 0 ? 0 : idx;
}

function armPlaybackMedia(){
  SceneRunner.armGestureMedia(mediaSceneIndex());
}

function togglePlay(){
  var btn = document.getElementById('btn-play');
  var state = SceneRunner.getState();

  if(state === 'idle'){
    SceneRunner.armGestureMedia(0);
    SceneRunner.playLesson();
    if(btn) btn.innerHTML = '&#9646;&#9646;';
  } else if(state === 'playing'){
    SceneRunner.pauseLesson();
    if(btn) btn.innerHTML = '&#9654;';
  } else if(state === 'paused'){
    armPlaybackMedia();
    SceneRunner.resumeLesson();
    if(btn) btn.innerHTML = '&#9646;&#9646;';
  } else if(state === 'complete'){
    SceneRunner.restartLesson();
    SceneRunner.armGestureMedia(0);
    SceneRunner.playLesson();
    if(btn) btn.innerHTML = '&#9646;&#9646;';
  }
}

function doRestart(){
  SceneRunner.pauseLesson();
  SceneRunner.restartLesson();
  var btn = document.getElementById('btn-play');
  if(btn) btn.innerHTML = '&#9654;';
}

function onSeek(ev){
  var bar = document.getElementById('lo-tl');
  if(!bar || !SceneRunner.getTotalDuration()) return;
  var rect = bar.getBoundingClientRect();
  if(!rect.width) return;
  var pct = Math.max(0, Math.min(1, (ev.clientX - rect.left) / rect.width));
  var targetMs = Math.round(pct * SceneRunner.getTotalDuration());
  var wasPlaying = SceneRunner.getState() === 'playing';
  SceneRunner.seekLesson(targetMs);
  var btn = document.getElementById('btn-play');
  if(btn){
    btn.innerHTML = wasPlaying ? '&#9646;&#9646;' : '&#9654;';
  }
}
</script>
