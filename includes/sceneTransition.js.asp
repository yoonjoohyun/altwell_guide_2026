<script>
/* SceneTransition — 씬 간 퇴장 연출 (신규 씬 추가 시 SceneRunner가 자동 적용) */
var SceneTransition = (function(){
  var gapMs = 3000;
  var holdMs = 1000;
  var fadeMs = 2000;

  function isCancelled(isCancelledFn){
    return isCancelledFn && isCancelledFn();
  }

  /* canvas 직계 스택 그룹만 — 중첩 g01-zone-wrap 개별 퇴장 방지 */
  function collectCanvasWraps(canvas){
    if(!canvas) return [];
    var list = canvas.querySelectorAll(':scope > .g01-zone-wrap:not(.is-hidden)');
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

  function fadeOpacityOnly(el, duration){
    if(!el) return Promise.resolve();
    return new Promise(function(resolve){
      el.style.transition = 'opacity ' + duration + 'ms cubic-bezier(.22,1,.36,1)';
      el.style.opacity = window.getComputedStyle(el).opacity || '1';
      void el.offsetWidth;
      el.style.opacity = '0';
      setTimeout(function(){
        el.style.transition = '';
        el.style.removeProperty('opacity');
        resolve();
      }, duration);
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

  function finalizeCanvasExit(wraps){
    var i;
    for(i = 0; i < wraps.length; i++){
      wraps[i].style.transition = '';
      wraps[i].style.removeProperty('opacity');
      if(typeof hideElement === 'function') hideElement(wraps[i]);
      else wraps[i].classList.add('is-hidden');
    }
  }

  async function fadeOutCanvasWraps(wraps, duration){
    if(!wraps.length) return;
    var jobs = [];
    var i;
    for(i = 0; i < wraps.length; i++){
      jobs.push(fadeOpacityOnly(wraps[i], duration));
    }
    await Promise.all(jobs);
    finalizeCanvasExit(wraps);
  }

  async function fadeOutCanvasFallback(canvas, duration){
    if(!canvas) return;
    await fadeOpacityOnly(canvas, duration);
    canvas.style.transition = '';
    canvas.style.removeProperty('opacity');
  }

  async function fadeOutPanel(duration){
    var els = collectPanelEls();
    if(!els.length){
      finalizePanelExit([]);
      return;
    }
    await Promise.all(els.map(function(el){ return fadeOpacityOnly(el, duration); }));
    finalizePanelExit(els);
  }

  async function runBetweenScenes(canvas, isCancelledFn){
    var wraps = collectCanvasWraps(canvas);

    if(holdMs > 0){
      await wait(holdMs);
      if(isCancelled(isCancelledFn)) return;
    }

    await Promise.all([
      fadeOutCanvasWraps(wraps, fadeMs),
      fadeOutPanel(fadeMs)
    ]);

    if(isCancelled(isCancelledFn)) return;

    if(!wraps.length){
      await fadeOutCanvasFallback(canvas, fadeMs);
    }
  }

  return {
    gapMs: gapMs,
    holdMs: holdMs,
    fadeMs: fadeMs,
    runBetweenScenes: runBetweenScenes
  };
})();
</script>
