<script>
/* Scene Runner - sequential scene playback engine */
var SceneRunner = (function(){
  var scenes = [];
  var lessonMeta = {};
  var currentIndex = -1;
  var state = 'idle';
  var elapsedMs = 0;
  var playToken = 0;
  var gestureMediaScene = -1;

  function getCanvas(){ return document.getElementById('motion-canvas'); }

  function getTotalDuration(){
    var total = 0;
    for(var i=0;i<scenes.length;i++) total += (scenes[i].duration || 0);
    return total;
  }

  function getSceneStartMs(index){
    var t = 0;
    for(var i=0;i<index;i++) t += (scenes[i].duration || 0);
    return t;
  }

  function fmtMs(ms){
    var s = Math.floor(ms / 1000);
    var m = Math.floor(s / 60);
    var sec = s % 60;
    return m + ':' + (sec < 10 ? '0' : '') + sec;
  }

  function renderTimelineMarkers(){
    var container = document.getElementById('lo-tl-markers');
    if(!container) return;
    container.innerHTML = '';
    var total = getTotalDuration();
    if(total <= 0 || scenes.length < 2) return;
    for(var i = 1; i < scenes.length; i++){
      var pct = (getSceneStartMs(i) / total) * 100;
      var mark = document.createElement('span');
      mark.className = 'lo-tl-marker';
      mark.style.left = pct + '%';
      mark.setAttribute('aria-hidden', 'true');
      container.appendChild(mark);
    }
  }

  function updatePlayerUI(){
    var total = getTotalDuration();
    var pct = total > 0 ? Math.min(100, (elapsedMs / total) * 100) : 0;
    var tlf = document.getElementById('lo-tlf');
    var tlt = document.getElementById('lo-tlt');
    var timeCurrent = document.getElementById('time-current');
    var timeTotal = document.getElementById('time-total');
    var sceneNum = document.getElementById('scene-number');
    if(tlf) tlf.style.width = pct + '%';
    if(tlt) tlt.style.left = pct + '%';
    if(timeCurrent) timeCurrent.textContent = fmtMs(elapsedMs);
    if(timeTotal) timeTotal.textContent = fmtMs(total);
    if(sceneNum){
      if(currentIndex >= 0 && scenes[currentIndex]){
        var label = '· 챕터 ' + (currentIndex + 1) + ' · ' + scenes[currentIndex].title;
        sceneNum.textContent = label;
        var caption = document.getElementById('scene-caption');
        if(caption) caption.title = label;
      } else {
        sceneNum.textContent = '· 준비';
        var cap = document.getElementById('scene-caption');
        if(cap) cap.removeAttribute('title');
      }
    }
  }

  function clearCanvas(){
    var canvas = getCanvas();
    if(canvas) canvas.innerHTML = '';
  }

  function resetInfoPanel(){
    var ids = ['scene-title-main','panel-scene-desc','scene-bullets'];
    for(var i=0;i<ids.length;i++){
      var el = document.getElementById(ids[i]);
      if(!el) continue;
      if(el.tagName === 'UL') el.innerHTML = '';
      else if(el.tagName === 'H2') el.innerHTML = '';
      else el.textContent = '';
      el.classList.add('is-hidden');
    }
  }

  function hideChapterTitle(){
    var chapter = document.getElementById('panel-fixed-title');
    if(chapter){
      chapter.textContent = '';
      chapter.classList.add('is-hidden');
    }
  }

  function resetLessonVisuals(){
    var canvas = getCanvas();
    if(canvas){
      resetMotionTree(canvas);
      canvas.style.opacity = '';
      canvas.style.transition = '';
    }
    var panel = document.getElementById('lo-panel');
    if(panel) resetMotionTree(panel);
    if(typeof resetScene === 'function') resetScene();
  }

  function resetAllScenes(){
    for(var i=0;i<scenes.length;i++){
      if(scenes[i].reset) scenes[i].reset();
    }
  }

  function applyPriorEndStates(targetScene){
    for(var j=0;j<targetScene;j++){
      if(scenes[j].endState) scenes[j].endState();
    }
  }

  function stopMedia(){
    if(typeof SceneMedia !== 'undefined' && SceneMedia.stop) SceneMedia.stop();
  }

  function startMedia(index, runToken){
    if(typeof SceneMedia === 'undefined' || !SceneMedia.play) return Promise.resolve();
    var scene = scenes[index];
    var delay = (scene && scene.mediaStartDelay > 0) ? scene.mediaStartDelay : 0;
    function isCancelled(){
      return runToken != null && (state !== 'playing' || runToken !== playToken);
    }
    function doPlay(){
      if(isCancelled()) return Promise.resolve();
      if(scene && scene.mediaSequence && scene.mediaSequence.length && SceneMedia.playSequence){
        return SceneMedia.playSequence(index, scene.mediaSequence, isCancelled);
      }
      return SceneMedia.play(index);
    }
    if(delay > 0) return wait(delay).then(doPlay);
    return doPlay();
  }

  function pauseMedia(){
    if(typeof SceneMedia !== 'undefined' && SceneMedia.pause) SceneMedia.pause();
  }

  function beginGestureMedia(index){
    if(gestureMediaScene === index) gestureMediaScene = -1;
    if(typeof SceneMedia === 'undefined') return;
    var scene = scenes[index];
    if(scene && scene.mediaStartDelay > 0 && SceneMedia.prepareScene){
      SceneMedia.prepareScene(index);
    } else if(scene && scene.mediaSequence && scene.mediaSequence.length && SceneMedia.prepareSequence){
      SceneMedia.prepareSequence(index, scene.mediaSequence);
    } else if(SceneMedia.beginScene){
      SceneMedia.beginScene(index);
    }
    if(SceneMedia.unlockGesture) SceneMedia.unlockGesture();
  }

  function isRunActive(runToken){
    return state === 'playing' && runToken === playToken;
  }

  async function playScene(index, runToken){
    var scene = scenes[index];
    if(!scene) return;

    currentIndex = index;
    if(scene.reset) scene.reset();
    updatePlayerUI();

    var startElapsed = getSceneStartMs(index);
    if(!isRunActive(runToken)) return;

    if(gestureMediaScene === index){
      beginGestureMedia(index);
    }

    var sceneCtx = {
      canvas: getCanvas(),
      lesson: lessonMeta,
      sceneIndex: index,
      sceneDuration: scene.duration || 0,
      mediaTitleMs: scene.mediaTitleMs || 0,
      isFollowUp: index > 0,
      isCancelled: function(){ return runToken !== playToken || state !== 'playing'; },
      reportProgress: function(ms){
        if(runToken !== playToken) return;
        elapsedMs = startElapsed + ms;
        updatePlayerUI();
      }
    };

    var animPromise;
    if(scene.play){
      animPromise = scene.play(sceneCtx);
    } else {
      animPromise = wait(scene.duration || 0);
    }

    await Promise.all([
      animPromise,
      startMedia(index, runToken)
    ]);

    if(!isRunActive(runToken)) return;

    stopMedia();

    if(scene.endState) scene.endState();

    if(index < scenes.length - 1){
      await wait(40);
    }

    if(!isRunActive(runToken)) return;

    elapsedMs = startElapsed + (scene.duration || 0);
    updatePlayerUI();
  }

  async function playLesson(){
    if(state === 'playing') return;

    var runToken = ++playToken;
    state = 'playing';

    try {
      if(currentIndex < 0){
        currentIndex = 0;
        elapsedMs = 0;
        resetLessonVisuals();
        clearCanvas();
        resetInfoPanel();
        hideChapterTitle();
        resetAllScenes();
      }

      for(var i=currentIndex;i<scenes.length;i++){
        if(!isRunActive(runToken)) return;
        await playScene(i, runToken);
        if(!isRunActive(runToken)) return;
        currentIndex = i + 1;
      }

      if(runToken !== playToken) return;

      state = 'complete';
      stopMedia();
      if(currentIndex >= scenes.length) currentIndex = scenes.length - 1;
      updatePlayerUI();
    } catch(err){
      if(runToken === playToken){
        state = 'paused';
        pauseMedia();
      }
      throw err;
    }
  }

  function pauseLesson(){
    if(state === 'playing'){
      state = 'paused';
      playToken++;
      gestureMediaScene = -1;
      pauseMedia();
    }
  }

  function resumeLesson(){
    if(state === 'paused'){
      return playLesson();
    }
  }

  function restartLesson(){
    playToken++;
    gestureMediaScene = -1;
    state = 'idle';
    currentIndex = -1;
    elapsedMs = 0;
    stopMedia();
    resetLessonVisuals();
    clearCanvas();
    resetInfoPanel();
    hideChapterTitle();
    resetAllScenes();
    updatePlayerUI();
  }

  function findSceneAt(timeMs){
    var idx = 0;
    for(var i=0;i<scenes.length;i++){
      if(timeMs >= getSceneStartMs(i)) idx = i;
    }
    return idx;
  }

  function prepareSceneAt(index){
    resetLessonVisuals();
    clearCanvas();
    resetInfoPanel();
    hideChapterTitle();
    resetAllScenes();
    applyPriorEndStates(index);
    currentIndex = index;
    elapsedMs = getSceneStartMs(index);
    updatePlayerUI();
  }

  function mountScenePreview(index){
    var scene = scenes[index];
    if(scene && scene._mountCanvas) scene._mountCanvas(getCanvas());
  }

  function seekLesson(timeMs){
    if(!scenes.length) return;

    var total = getTotalDuration();
    if(total <= 0) return;

    timeMs = Math.max(0, Math.min(timeMs, total));
    var targetScene = findSceneAt(timeMs);
    var wasPlaying = state === 'playing';

    playToken++;
    gestureMediaScene = -1;
    state = 'paused';
    pauseMedia();

    prepareSceneAt(targetScene);

    if(typeof SceneMedia !== 'undefined' && SceneMedia.prepareScene){
      SceneMedia.prepareScene(targetScene);
    }

    if(wasPlaying){
      gestureMediaScene = targetScene;
      playLesson();
    } else {
      mountScenePreview(targetScene);
    }
  }

  return {
    registerScene: function(scene){ scenes.push(scene); },
    registerScenes: function(arr){
      for(var i=0;i<arr.length;i++) scenes.push(arr[i]);
    },
    setLessonMeta: function(meta){ lessonMeta = meta || {}; },
    getScenes: function(){ return scenes; },
    armGestureMedia: function(sceneIndex){
      gestureMediaScene = sceneIndex;
    },
    playLesson: playLesson,
    pauseLesson: pauseLesson,
    resumeLesson: resumeLesson,
    restartLesson: restartLesson,
    seekLesson: seekLesson,
    getCurrentScene: function(){
      return currentIndex >= 0 ? scenes[currentIndex] : null;
    },
    getCurrentIndex: function(){ return currentIndex; },
    getTotalDuration: getTotalDuration,
    getState: function(){ return state; },
    getPlayToken: function(){ return playToken; },
    updatePlayerUI: updatePlayerUI,
    renderTimelineMarkers: renderTimelineMarkers,
    init: function(){
      var total = getTotalDuration();
      var timeCurrent = document.getElementById('time-current');
      var timeTotal = document.getElementById('time-total');
      if(timeCurrent) timeCurrent.textContent = '0:00';
      if(timeTotal) timeTotal.textContent = fmtMs(total);
      renderTimelineMarkers();
      updatePlayerUI();
    }
  };
})();
</script>
