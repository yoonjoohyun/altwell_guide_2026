<link rel="stylesheet" href="/_css/video_controller.css"/>
  <!-- ③ 영상 하단 컨트롤러 (디자인 시안) -->
  <footer id="lo-ctrl" aria-label="영상 컨트롤러">
    <div id="lo-progress-wrap">
      <div id="lo-tl" role="slider" aria-label="재생 타임라인" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
        <div id="lo-tl-markers"></div>
        <div id="lo-tlf"></div>
        <div id="lo-tlt"></div>
      </div>
    </div>
    <div id="lo-cr">
      <button type="button" id="btn-play" data-state="paused" aria-label="재생">
        <span class="btn-play-icon" aria-hidden="true"></span>
      </button>
      <span id="time-current">0:00</span>
      <span class="lo-time-sep" aria-hidden="true">/</span>
      <span id="time-total">3:00</span>
      <span class="lo-scene-caption" id="scene-caption">
        <span id="scene-number">· Scene 01</span>
      </span>
      <button type="button" id="btn-list" aria-label="리스트로 이동">
        <span class="btn-list-icon" aria-hidden="true"><span></span><span></span><span></span></span>
      </button>
    </div>
  </footer>
<script>
/* Player Controls — UI → SceneRunner (inlined; nested SSI include breaks on IIS) */
function setPlayButtonState(playing){
  var btn = document.getElementById('btn-play');
  if(!btn) return;
  btn.setAttribute('data-state', playing ? 'playing' : 'paused');
  btn.setAttribute('aria-label', playing ? '일시정지' : '재생');
}

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
    if(btn) setPlayButtonState(true);
  } else if(state === 'playing'){
    SceneRunner.pauseLesson();
    if(btn) setPlayButtonState(false);
  } else if(state === 'paused'){
    armPlaybackMedia();
    SceneRunner.resumeLesson();
    if(btn) setPlayButtonState(true);
  } else if(state === 'complete'){
    SceneRunner.restartLesson();
    SceneRunner.armGestureMedia(0);
    SceneRunner.playLesson();
    if(btn) setPlayButtonState(true);
  }
}

function doRestart(){
  SceneRunner.pauseLesson();
  SceneRunner.restartLesson();
  var btn = document.getElementById('btn-play');
  if(btn) setPlayButtonState(false);
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
  if(btn) setPlayButtonState(wasPlaying);
}

(function(){
  var backUrl = (function(){
    var p = new URLSearchParams(location.search).get('from');
    var file = p === 'sim' ? 'sim.asp' : 'guide.asp';
    var path = location.pathname || '';
    if(/\/series\/[^/]+\//.test(path)){
      return '../../' + file;
    }
    return file;
  })();

  function closePlayer(){
    if(typeof SceneRunner !== 'undefined' && SceneRunner.pauseLesson){
      SceneRunner.pauseLesson();
    }
    if(typeof SceneMedia !== 'undefined' && SceneMedia.stop){
      SceneMedia.stop();
    }
    location.href = backUrl;
  }

  function syncPlayButton(){
    var btn = document.getElementById('btn-play');
    if(!btn || typeof SceneRunner === 'undefined') return;
    setPlayButtonState(SceneRunner.getState() === 'playing');
  }

  function wireControls(){
    var play = document.getElementById('btn-play');
    var tl = document.getElementById('lo-tl');
    var listBtn = document.getElementById('btn-list');

    if(play && typeof togglePlay === 'function'){
      play.onclick = togglePlay;
    }

    if(tl && typeof onSeek === 'function'){
      tl.onclick = onSeek;
    }

    if(listBtn){
      listBtn.onclick = closePlayer;
    }

    syncPlayButton();
  }

  wireControls();
  window.closePlayer = closePlayer;
})();
</script>
