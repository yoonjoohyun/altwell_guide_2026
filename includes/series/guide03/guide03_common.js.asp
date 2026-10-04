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
    panelBulletTimeline: panelBulletTimeline,
    finishSceneHold: finishSceneHold
  };
})();
</script>
