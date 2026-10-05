<script>
var Guide03Scene05 = defineScene({
  id: Guide03Scene05Config.id,
  title: Guide03Scene05Config.title,
  duration: Guide03Scene05Config.duration,
  mediaSequence: Guide03Scene05Config.media.sequence,
  mediaFallbackMs: Guide03Scene05Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide03Scene05Config.panelCls);
    if(typeof Guide03Scene05Layout !== 'undefined') Guide03Scene05Layout.unbind();
    Guide03.resetScene(Guide03Scene05Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide03Scene05Config.panelCls);
    tl = Guide03.timeline(ctx);
    Guide03.resetScene(Guide03Scene05Config.canvasCls);
    Guide03.mountStage(canvas, Guide03Scene05Config.canvasCls);
    assets = setupGuide03Scene05(canvas);

    await Promise.all([
      runGuide03Scene05(tl, assets, ctx),
      Guide03.panelBulletTimeline(
        tl,
        Guide03Scene05Config.panel.title,
        Guide03Scene05Config.panel.bullets,
        guide03Scene05PanelFlashes(ctx)
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide03.finishSceneHold(tl, ctx.sceneDuration || Guide03Scene05Config.duration);
  }
});

function guide03Scene05Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

function guide03Scene05Fit(){
  if(typeof Guide03Scene05Layout !== 'undefined') Guide03Scene05Layout.schedule();
}

async function guide03Scene05Reveal(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g03-enter');
  guide03Scene05Fit();
  await wait(760);
  el.classList.remove('g03-enter');
}

function guide03Scene05Fill(fill){
  if(!fill) return;
  fill.style.transition = 'none';
  fill.style.width = '0%';
  void fill.offsetWidth;
  fill.style.transition = 'width 6000ms linear';
  fill.style.width = '100%';
}

async function runGuide03Scene05(tl, assets, ctx){
  var T = Guide03Scene05Config.T;
  var at = function(ms){ return guide03Scene05AtMain(ms, ctx); };
  var i;

  for(i = 0; i < assets.partners.length; i++){
    await tl.wait(T.partners[i]);
    if(guide03Scene05Cancelled(ctx)) return;
    await guide03Scene05Reveal(assets.partners[i]);
  }

  for(i = 0; i < assets.autos.length; i++){
    await tl.wait(at(T.autos[i]));
    if(guide03Scene05Cancelled(ctx)) return;
    await guide03Scene05Reveal(assets.autos[i]);
  }

  await tl.wait(at(T.gauge));
  if(guide03Scene05Cancelled(ctx)) return;
  await guide03Scene05Reveal(assets.gauge);

  for(i = 0; i < T.boxes.length; i++){
    await tl.wait(at(T.boxes[i]));
    if(guide03Scene05Cancelled(ctx)) return;
    if(i === 0) guide03Scene05Fill(assets.fill);
    await Promise.all([
      guide03Scene05Reveal(assets.boxes[0][i]),
      guide03Scene05Reveal(assets.boxes[1][i])
    ]);
  }

  await tl.wait(at(T.stable));
  if(guide03Scene05Cancelled(ctx)) return;
  await guide03Scene05Reveal(assets.stable);
}
</script>
