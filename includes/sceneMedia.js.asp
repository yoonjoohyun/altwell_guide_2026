<script>
/* Scene Media - 씬별 음성 (voice/{seriesId}/sceneNN.mp4) */
var SceneMedia = (function(){
  var seriesId = '';
  var media = null;
  var currentIndex = -1;
  var activePath = '';

  function padSceneNum(n){
    return n < 10 ? '0' + n : String(n);
  }

  function getMediaPath(sceneIndex, part){
    var num = padSceneNum(sceneIndex + 1);
    /* voice_stream.asp는 사이트 루트 고정 (series/season01/ 등 하위 경로 페이지에서도 동일) */
    var url = '/voice_stream.asp?series=' + encodeURIComponent(seriesId) + '&scene=' + num;
    if(part) url += '&part=' + encodeURIComponent(part);
    return url;
  }

  function ensureMedia(){
    if(!media){
      var existing = document.getElementById('scene-media');
      if(existing && existing.tagName === 'VIDEO'){
        media = document.createElement('audio');
        media.id = 'scene-media';
        media.preload = 'auto';
        media.controls = false;
        media.style.cssText = 'position:fixed;left:0;top:0;width:1px;height:1px;opacity:0;pointer-events:none;z-index:-1';
        existing.parentNode.replaceChild(media, existing);
      } else if(existing){
        media = existing;
      } else {
        media = document.createElement('audio');
        media.id = 'scene-media';
        media.preload = 'auto';
        media.controls = false;
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

  function prepareScenePart(sceneIndex, part){
    var el = ensureMedia();
    var path = getMediaPath(sceneIndex, part || '');
    currentIndex = sceneIndex;
    activePath = path;

    if(el.getAttribute('data-active') !== path || el.src !== path){
      el.setAttribute('data-active', path);
      el.src = path;
      el.currentTime = 0;
      el.load();
    } else {
      el.currentTime = 0;
    }
    el.pause();
    return path;
  }

  /* Call synchronously inside a user click/tap handler (mobile unlock) */
  function beginScene(sceneIndex){
    return prepareScenePart(sceneIndex, '');
  }

  /* 제스처 잠금 해제 — 실제 재생은 loadAudioSrc 이후 playSequence/play에서 */
  function unlockGesture(){
    var el = ensureMedia();
    el.muted = false;
    el.volume = 1;
    var p = el.play();
    if(p && p.catch){
      p.catch(function(){});
      if(p.then){
        p.then(function(){
          el.pause();
          el.currentTime = 0;
        });
      }
    }
  }

  function play(sceneIndex){
    var el = ensureMedia();
    var path = getMediaPath(sceneIndex);

    if(currentIndex === sceneIndex && activePath === path && !el.paused){
      return Promise.resolve(path);
    }

    return loadAudioSrc(el, path).then(function(){
      attachPlayRetry(el);
      return path;
    });
  }

  function pause(){
    var el = ensureMedia();
    if(!el.paused) el.pause();
  }

  function resume(){
    var el = ensureMedia();
    if(el.src && el.paused) attachPlayRetry(el);
  }

  var FALLBACK_MS = [29000, 33000, 26000, 30000, 34000, 25000, 52000];

  function probeDurationPath(path, fallbackMs){
    return new Promise(function(resolve){
      var probe = document.createElement('audio');
      probe.preload = 'metadata';
      function done(ms){
        probe.removeAttribute('src');
        probe.load();
        resolve(ms);
      }
      probe.addEventListener('loadedmetadata', function(){
        if(probe.duration && isFinite(probe.duration)){
          done(Math.round(probe.duration * 1000));
        } else {
          done(fallbackMs || 30000);
        }
      });
      probe.addEventListener('error', function(){
        done(fallbackMs || 30000);
      });
      probe.src = path;
      probe.load();
    });
  }

  function probeDuration(sceneIndex){
    return probeDurationPath(getMediaPath(sceneIndex), FALLBACK_MS[sceneIndex] || 30000);
  }

  function probeSceneDuration(sceneIndex, scene){
    if(scene && scene.mediaSequence && scene.mediaSequence.length){
      var parts = scene.mediaSequence;
      var fallbacks = scene.mediaFallbackMs || [];
      var chain = Promise.resolve(0);
      parts.forEach(function(item, idx){
        chain = chain.then(function(sum){
          var path = getMediaPath(sceneIndex, item.part || '');
          return probePathAvailable(path).then(function(ok){
            if(!ok) return sum;
            var fb = fallbacks[idx] || 30000;
            return probeDurationPath(path, fb).then(function(ms){
              return sum + ms;
            });
          });
        });
      });
      return chain.then(function(total){
        return total > 0 ? total : probeDuration(sceneIndex);
      });
    }
    return probeDuration(sceneIndex);
  }

  function waitAudioEnd(el, isCancelled){
    return new Promise(function(resolve){
      if(isCancelled && isCancelled()) return resolve();
      if(el.ended) return resolve();
      function finish(){
        el.removeEventListener('ended', finish);
        el.removeEventListener('error', finish);
        resolve();
      }
      el.addEventListener('ended', finish);
      el.addEventListener('error', finish);
    });
  }

  function probePathAvailable(path){
    return new Promise(function(resolve){
      var probe = document.createElement('audio');
      probe.preload = 'metadata';
      function done(ok){
        probe.removeAttribute('src');
        probe.load();
        resolve(ok);
      }
      probe.addEventListener('loadedmetadata', function(){
        done(!!(probe.duration && isFinite(probe.duration) && probe.duration > 0));
      });
      probe.addEventListener('error', function(){
        done(false);
      });
      probe.src = path;
      probe.load();
    });
  }

  function filterSequence(sceneIndex, sequence){
    if(!sequence || !sequence.length) return Promise.resolve([{ part: 'main' }]);
    var chain = Promise.resolve([]);
    sequence.forEach(function(item){
      chain = chain.then(function(list){
        var path = getMediaPath(sceneIndex, item.part || '');
        return probePathAvailable(path).then(function(ok){
          if(ok) list.push(item);
          return list;
        });
      });
    });
    return chain.then(function(list){
      return list.length ? list : [{ part: 'main' }];
    });
  }

  function loadAudioSrc(el, path){
    return new Promise(function(resolve, reject){
      var timer = null;

      function ready(){
        cleanup();
        el.currentTime = 0;
        resolve();
      }
      function failed(){
        cleanup();
        reject(new Error('media load failed'));
      }
      function cleanup(){
        if(timer) clearTimeout(timer);
        el.removeEventListener('canplaythrough', ready);
        el.removeEventListener('canplay', onCanPlay);
        el.removeEventListener('error', failed);
      }
      function onCanPlay(){
        if(el.readyState >= 3) ready();
      }

      if(el.getAttribute('data-active') === path && el.src === path && el.readyState >= 3){
        el.currentTime = 0;
        return resolve();
      }

      el.setAttribute('data-active', path);
      el.addEventListener('canplaythrough', ready, { once: true });
      el.addEventListener('canplay', onCanPlay, { once: true });
      el.addEventListener('error', failed, { once: true });
      timer = setTimeout(function(){
        if(el.getAttribute('data-active') === path && el.readyState >= 2) ready();
      }, 3000);

      if(el.src !== path){
        el.src = path;
        el.load();
      } else {
        el.load();
      }
    });
  }

  function prepareSequencePart(sceneIndex, item){
    var part = item && item.part ? item.part : '';
    return prepareScenePart(sceneIndex, part);
  }

  function prepareSequence(sceneIndex, sequence){
    if(!sequence || !sequence.length) return beginScene(sceneIndex);
    return prepareSequencePart(sceneIndex, sequence[0]);
  }

  function beginSequencePart(sceneIndex, item){
    return prepareSequencePart(sceneIndex, item);
  }

  function beginSequence(sceneIndex, sequence){
    return prepareSequence(sceneIndex, sequence);
  }

  function playPartsFrom(sceneIndex, sequence, startIdx, isCancelled){
    var el = ensureMedia();
    var i = startIdx;

    function nextPart(){
      if(isCancelled && isCancelled()) return Promise.resolve();
      if(i >= sequence.length) return Promise.resolve();

      var item = sequence[i++];
      var part = item.part || '';
      var path = getMediaPath(sceneIndex, part);
      currentIndex = sceneIndex;
      activePath = path;

      return loadAudioSrc(el, path).then(function(){
        if(isCancelled && isCancelled()) return;
        attachPlayRetry(el);
        return waitAudioEnd(el, isCancelled);
      }).catch(function(){
        return nextPart();
      }).then(nextPart);
    }

    return nextPart();
  }

  function playSequence(sceneIndex, sequence, isCancelled){
    if(!sequence || !sequence.length) return play(sceneIndex);

    var el = ensureMedia();
    if(!el.paused) el.pause();

    return playPartsFrom(sceneIndex, sequence, 0, isCancelled);
  }

  function applyDurations(scenes, onComplete){
    if(!scenes || !scenes.length){
      if(onComplete) onComplete(false);
      return;
    }
    var pending = scenes.length;
    var changed = false;
    scenes.forEach(function(scene, i){
      if(!scene.duration || scene.duration <= 0){
        scene.duration = FALLBACK_MS[i] || 30000;
        changed = true;
      }
      probeSceneDuration(i, scene).then(function(ms){
        if(ms > 0 && scene.duration !== ms){
          scene.duration = ms;
          changed = true;
        }
        pending--;
        if(pending === 0 && onComplete) onComplete(changed);
      });
    });
  }

  return {
    setSeriesId: function(id){ if(id) seriesId = id; },
    getMediaPath: getMediaPath,
    prepareScene: prepareScene,
    prepareScenePart: prepareScenePart,
    prepareSequence: prepareSequence,
    unlockGesture: unlockGesture,
    beginScene: beginScene,
    play: play,
    pause: pause,
    resume: resume,
    stop: stop,
    applyDurations: applyDurations,
    playSequence: playSequence,
    beginSequence: beginSequence,
    beginSequencePart: beginSequencePart,
    filterSequence: filterSequence,
    probePathAvailable: probePathAvailable,
    probeDurationPath: probeDurationPath,
    probeSceneDuration: probeSceneDuration,
    getCurrentIndex: function(){ return currentIndex; }
  };
})();
</script>
