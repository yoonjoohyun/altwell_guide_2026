<script>
/* SceneTransition — 씬 간 퇴장 연출 (신규 씬 추가 시 SceneRunner가 자동 적용) */
var SceneTransition = (function(){
  var gapMs = 3000;
  var fadeMs = 2000;

  function isCancelled(isCancelledFn){
    return isCancelledFn && isCancelledFn();
  }

  function collectCanvasWraps(canvas){
    if(!canvas) return [];
    var list = canvas.querySelectorAll('.g01-zone-wrap:not(.is-hidden)');
    var out = [];
    var i;
    for(i = 0; i < list.length; i++) out.push(list[i]);
    return out;
  }

  function collectPanelEls(){
    var ids = ['scene-title-main', 'scene-bullets', 'panel-scene-desc'];
    var out = [];
    var i;
    for(i = 0; i < ids.length; i++){
      var el = document.getElementById(ids[i]);
      if(el && !el.classList.contains('is-hidden')) out.push(el);
    }
    return out;
  }

  function fadeElement(el, duration){
    if(!el) return Promise.resolve();
    return new Promise(function(resolve){
      el.style.transition =
        'opacity ' + duration + 'ms cubic-bezier(.22,1,.36,1), ' +
        'transform ' + duration + 'ms cubic-bezier(.22,1,.36,1)';
      el.style.opacity = '1';
      el.style.transform = 'translateY(0)';
      void el.offsetWidth;
      el.style.opacity = '0';
      el.style.transform = 'translateY(6px)';
      setTimeout(resolve, duration);
    });
  }

  function stripScenePanelClasses(){
    var panel = document.getElementById('lo-panel');
    if(!panel || !panel.classList) return;
    var remove = [];
    var i;
    for(i = 0; i < panel.classList.length; i++){
      if(/^scene\d+-panel$/.test(panel.classList[i])) remove.push(panel.classList[i]);
    }
    for(i = 0; i < remove.length; i++) panel.classList.remove(remove[i]);
  }

  function finalizePanelExit(els){
    var i;
    for(i = 0; i < els.length; i++){
      els[i].style.transition = '';
      els[i].style.opacity = '';
      els[i].style.transform = '';
    }
    if(typeof ScenePanel !== 'undefined' && ScenePanel.reset){
      ScenePanel.reset();
    } else {
      for(i = 0; i < els.length; i++){
        if(typeof hideElement === 'function') hideElement(els[i]);
        else els[i].classList.add('is-hidden');
      }
    }
    stripScenePanelClasses();
  }

  async function fadeOutCanvasWraps(wraps, duration){
    if(!wraps.length) return;

    var i;
    if(typeof Guide01 !== 'undefined'){
      for(i = 0; i < wraps.length; i++){
        if(Guide01.stopIdleFloat) Guide01.stopIdleFloat(wraps[i]);
      }
    }

    var jobs = [];
    for(i = 0; i < wraps.length; i++){
      if(typeof Guide01 !== 'undefined' && Guide01.fadeZoned){
        jobs.push(Guide01.fadeZoned(wraps[i], false, { duration: duration }));
      } else if(typeof G01ZonedAnim !== 'undefined' && G01ZonedAnim.exitHide){
        jobs.push(G01ZonedAnim.exitHide(wraps[i], { duration: duration }));
      } else {
        jobs.push(fadeElement(wraps[i], duration));
      }
    }

    await Promise.all(jobs);
  }

  async function fadeOutCanvasFallback(canvas, duration){
    if(!canvas) return;
    canvas.style.transition = 'opacity ' + duration + 'ms cubic-bezier(.22,1,.36,1)';
    canvas.style.opacity = '1';
    void canvas.offsetWidth;
    canvas.style.opacity = '0';
    await wait(duration);
    canvas.style.transition = '';
    canvas.style.opacity = '';
  }

  async function fadeOutPanel(duration){
    var els = collectPanelEls();
    if(!els.length){
      finalizePanelExit([]);
      return;
    }
    await Promise.all(els.map(function(el){ return fadeElement(el, duration); }));
    finalizePanelExit(els);
  }

  async function runBetweenScenes(canvas, isCancelledFn){
    var duration = fadeMs;
    var wraps = collectCanvasWraps(canvas);

    await Promise.all([
      fadeOutCanvasWraps(wraps, duration),
      fadeOutPanel(duration)
    ]);

    if(isCancelled(isCancelledFn)) return;

    if(!wraps.length){
      await fadeOutCanvasFallback(canvas, duration);
      if(isCancelled(isCancelledFn)) return;
    }

    var rest = gapMs - duration;
    if(rest > 0) await wait(rest);
  }

  return {
    gapMs: gapMs,
    fadeMs: fadeMs,
    runBetweenScenes: runBetweenScenes
  };
})();
</script>
