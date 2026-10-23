<script>
/* guide03 공통. guide01·guide02 런타임 파일은 수정하지 않는다. */
var Guide03 = (function(){
  function timeline(ctx){
    var origin = performance.now();
    var elapsed = 0;
    return {
      wait: async function(ms){
        var target = origin + ms;
        var now = performance.now();
        if(target > now) await wait(target - now);
        elapsed = ms;
        if(ctx && ctx.reportProgress) ctx.reportProgress(elapsed);
      },
      finish: async function(){
        var total = (ctx && ctx.sceneDuration) || elapsed;
        var target = origin + total;
        var now = performance.now();
        if(target > now) await wait(target - now);
        elapsed = total;
        if(ctx && ctx.reportProgress) ctx.reportProgress(elapsed);
      }
    };
  }

  function resetScene(extraCls){
    var canvas = document.getElementById('motion-canvas');
    if(typeof CanvasStage !== 'undefined'){
      CanvasStage.reset(canvas, extraCls ? ('g03-canvas ' + extraCls) : 'g03-canvas');
    }else if(canvas){
      canvas.innerHTML = '';
    }
    if(typeof ScenePanel !== 'undefined' && ScenePanel.reset) ScenePanel.reset();
  }

  function mountStage(canvas, extraCls){
    if(!canvas) return;
    canvas.classList.add('g03-canvas');
    if(extraCls) canvas.classList.add(extraCls);
  }

  function cloneTemplate(templateId){
    var host = document.querySelector('#guide03-templates [data-template="' + templateId + '"]');
    if(!host || !host.firstElementChild) return null;
    return host.firstElementChild.cloneNode(true);
  }

  function placeAtZone(el, zone){
    if(typeof G01ZonedAnim !== 'undefined' && G01ZonedAnim.placeAtZone){
      return G01ZonedAnim.placeAtZone(el, zone);
    }
    return el;
  }

  function badgeAlone(stage, badge){
    var nodes;
    var i;
    var shown = 0;
    var only = null;
    if(!stage || !badge || badge.classList.contains('is-hidden')) return false;
    nodes = stage.children;
    for(i = 0; i < nodes.length; i++){
      if(nodes[i].classList.contains('is-hidden')) continue;
      if((nodes[i].offsetWidth || 0) < 2 && (nodes[i].offsetHeight || 0) < 2) continue;
      shown++;
      only = nodes[i];
    }
    return shown === 1 && only === badge;
  }

  function fitGroup(canvas, inner, stage, badge, after, groupInset){
    var w;
    var h;
    var ratio;
    var fit;
    var ro;
    if(!canvas || !inner || !stage) return;
    if(groupInset != null && groupInset > 0) stage._g03GroupInset = groupInset;
    else if(stage._g03GroupInset != null) groupInset = stage._g03GroupInset;
    w = stage.offsetWidth || 0;
    h = stage.offsetHeight || 0;
    if(w >= 2 && h >= 2 && canvas.clientWidth && canvas.clientHeight){
      ratio = badgeAlone(stage, badge) ? 0.4 : (groupInset != null && groupInset > 0 ? groupInset : 0.8);
      fit = Math.min((canvas.clientWidth * ratio) / w, (canvas.clientHeight * ratio) / h);
      if(badgeAlone(stage, badge) && stage._g03BadgeAloneScale > 0){
        fit *= stage._g03BadgeAloneScale;
      }
      if(fit > 0) inner.style.setProperty('--group-scale', String(Math.round(fit * 1000) / 1000));
    }
    if(after) after();
    if(stage._g03Watch || typeof ResizeObserver === 'undefined') return;
    stage._g03Watch = true;
    ro = new ResizeObserver(function(){
      if(!stage.isConnected){
        ro.disconnect();
        return;
      }
      fitGroup(canvas, inner, stage, badge, after);
    });
    ro.observe(stage);
  }

  function panelInitBullets(items){
    setSceneBullets(items);
    if(!items || !items.length){
      hideElement('#scene-bullets');
      return;
    }
    showElement('#scene-bullets');
    var bullets = document.querySelectorAll('#scene-bullets .bullet-item');
    var i;
    for(i = 0; i < bullets.length; i++){
      bullets[i].classList.add('is-dim');
      bullets[i].classList.remove('is-emphasis', 'g03-flash');
    }
  }

  function panelFlashBullet(index){
    var bullets = document.querySelectorAll('#scene-bullets .bullet-item');
    var i;
    for(i = 0; i < bullets.length; i++){
      bullets[i].classList.toggle('is-emphasis', i === index);
      bullets[i].classList.toggle('is-dim', i !== index);
      bullets[i].classList.remove('g03-flash');
    }
    if(bullets[index]) bullets[index].classList.add('g03-flash');
  }

  async function panelBulletTimeline(tl, title, items, flashes){
    await tl.wait(0);
    setSceneTitle(title);
    showElement('#scene-title-main');
    panelInitBullets(items || []);
    var i;
    flashes = flashes || [];
    for(i = 0; i < flashes.length; i++){
      await tl.wait(flashes[i].at);
      panelFlashBullet(flashes[i].index);
    }
  }

  async function finishSceneHold(tl, duration){
    await tl.wait(duration);
    await tl.finish();
  }

  return {
    timeline: timeline,
    resetScene: resetScene,
    mountStage: mountStage,
    cloneTemplate: cloneTemplate,
    placeAtZone: placeAtZone,
    fitGroup: fitGroup,
    panelBulletTimeline: panelBulletTimeline,
    panelFlashBullet: panelFlashBullet,
    finishSceneHold: finishSceneHold
  };
})();

function guide03EaseOpen(slot){
  var h;
  var w;
  var anim;
  if(!slot) return Promise.resolve();
  slot.style.transition = 'none';
  slot.classList.add('is-open', 'is-settled');
  h = slot.offsetHeight;
  w = slot.offsetWidth;
  if(h < 1 && w < 1){
    slot.style.transition = '';
    return Promise.resolve();
  }
  slot.style.overflow = 'hidden';
  anim = slot.animate([
    { height: '0px', width: '0px', opacity: 0 },
    { height: h + 'px', width: w + 'px', opacity: 1 }
  ], { duration: 740, easing: 'ease-in-out', fill: 'both' });
  return anim.finished.then(function(){
    anim.cancel();
    slot.style.overflow = '';
    slot.style.transition = '';
  }, function(){
    slot.style.overflow = '';
    slot.style.transition = '';
  });
}
</script>
