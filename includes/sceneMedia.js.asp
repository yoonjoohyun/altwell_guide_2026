<script>
/* Scene Media - voice/mp4 playback per scene */
var SceneMedia = (function(){
  var seriesId = '01_base_business_running';
  var media = null;
  var currentIndex = -1;
  var activePath = '';

  function padSceneNum(n){
    return n < 10 ? '0' + n : String(n);
  }

  function getPageBase(){
    var path = location.pathname || '/';
    return path.substring(0, path.lastIndexOf('/') + 1);
  }

  function getMediaPath(sceneIndex){
    var num = padSceneNum(sceneIndex + 1);
    return getPageBase() + 'voice_stream.asp?series=' + encodeURIComponent(seriesId) + '&scene=' + num;
  }

  function ensureMedia(){
    if(!media){
      media = document.getElementById('scene-media');
      if(!media){
        media = document.createElement('video');
        media.id = 'scene-media';
        media.preload = 'auto';
        media.setAttribute('playsinline', '');
        media.setAttribute('webkit-playsinline', '');
        media.playsInline = true;
        media.controls = false;
        media.muted = false;
        media.volume = 1;
        media.style.cssText = 'position:fixed;left:0;top:0;width:1px;height:1px;opacity:0;pointer-events:none;z-index:-1';
        document.body.appendChild(media);
      }
    }
    media.muted = false;
    media.volume = 1;
    return media;
  }

  function attachPlayRetry(el){
    var p = el.play();
    if(!p || !p.catch) return p;
    p.catch(function(){
      var retry = function(){
        el.removeEventListener('canplay', retry);
        el.removeEventListener('loadeddata', retry);
        var p2 = el.play();
        if(p2 && p2.catch) p2.catch(function(){});
      };
      if(el.readyState >= 2) retry();
      else {
        el.addEventListener('canplay', retry, { once: true });
        el.addEventListener('loadeddata', retry, { once: true });
      }
    });
    return p;
  }

  function stop(){
    var el = ensureMedia();
    el.pause();
    el.removeAttribute('src');
    el.removeAttribute('data-active');
    el.load();
    currentIndex = -1;
    activePath = '';
  }

  function prepareScene(sceneIndex){
    var el = ensureMedia();
    var path = getMediaPath(sceneIndex);
    currentIndex = sceneIndex;
    activePath = path;

    if(el.getAttribute('data-active') !== path){
      el.setAttribute('data-active', path);
      el.src = path;
      el.currentTime = 0;
      el.load();
    } else {
      el.currentTime = 0;
    }
    el.pause();
  }

  /* Call synchronously inside a user click/tap handler (mobile unlock) */
  function beginScene(sceneIndex){
    var el = ensureMedia();
    var path = getMediaPath(sceneIndex);
    currentIndex = sceneIndex;
    activePath = path;

    if(el.getAttribute('data-active') !== path){
      el.setAttribute('data-active', path);
      el.src = path;
      el.currentTime = 0;
      el.load();
    } else if(el.paused){
      el.currentTime = 0;
    }

    return attachPlayRetry(el);
  }

  function play(sceneIndex){
    var el = ensureMedia();
    var path = getMediaPath(sceneIndex);

    if(currentIndex === sceneIndex && activePath === path && !el.paused){
      return Promise.resolve(path);
    }

    beginScene(sceneIndex);
    return Promise.resolve(path);
  }

  function pause(){
    var el = ensureMedia();
    if(!el.paused) el.pause();
  }

  function resume(){
    var el = ensureMedia();
    if(el.src && el.paused) attachPlayRetry(el);
  }

  function probeDuration(sceneIndex){
    return new Promise(function(resolve){
      var path = getMediaPath(sceneIndex);
      var probe = document.createElement('video');
      probe.preload = 'metadata';
      probe.muted = true;
      probe.setAttribute('playsinline', '');
      function done(ms){
        probe.removeAttribute('src');
        probe.load();
        resolve(ms);
      }
      probe.addEventListener('loadedmetadata', function(){
        if(probe.duration && isFinite(probe.duration)){
          done(Math.round(probe.duration * 1000));
        } else {
          done(0);
        }
      });
      probe.addEventListener('error', function(){ done(0); });
      probe.src = path;
      probe.load();
    });
  }

  function applyDurations(scenes, onComplete){
    if(!scenes || !scenes.length){
      if(onComplete) onComplete();
      return;
    }
    var pending = scenes.length;
    var changed = false;
    scenes.forEach(function(scene, i){
      probeDuration(i).then(function(ms){
        if(ms > 0 && (!scene.duration || scene.duration <= 0)){
          scene.duration = ms;
          changed = true;
        }
        pending--;
        if(pending === 0 && onComplete) onComplete(changed);
      });
    });
  }

  return {
    setSeriesId: function(id){ seriesId = id || seriesId; },
    getMediaPath: getMediaPath,
    prepareScene: prepareScene,
    beginScene: beginScene,
    play: play,
    pause: pause,
    resume: resume,
    stop: stop,
    applyDurations: applyDurations,
    getCurrentIndex: function(){ return currentIndex; }
  };
})();
</script>
