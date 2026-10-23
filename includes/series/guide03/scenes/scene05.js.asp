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
  var motion;
  if(!el) return;
  showElement(el);
  motion = (el.classList.contains('g03-s05-note') || el.classList.contains('g03-s05-coda-badge')) ? el.firstElementChild : el;
  if(motion) motion.classList.add('g03-enter');
  guide03Scene05Fit();
  await wait(760);
  if(motion) motion.classList.remove('g03-enter');
}

async function guide03Scene05Open(slot){
  var done;
  if(!slot) return;
  done = guide03EaseOpen(slot);
  guide03Scene05Fit();
  await done;
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

  await tl.wait(guide03Scene05AddAt(T.coda.board, ctx));
  if(guide03Scene05Cancelled(ctx)) return;
  if(assets.opening) assets.opening.classList.add('is-gone');
  showElement(assets.coda.root);
  if(Guide03.panelFlashBullet) Guide03.panelFlashBullet(2);
  await guide03Scene05Reveal(assets.coda.board);

  await tl.wait(guide03Scene05AddAt(T.coda.self, ctx));
  if(guide03Scene05Cancelled(ctx)) return;
  await guide03Scene05Open(assets.coda.members[0].slot);

  for(i = 0; i < T.coda.partners.length; i++){
    await tl.wait(guide03Scene05AddAt(T.coda.partners[i], ctx));
    if(guide03Scene05Cancelled(ctx)) return;
    await guide03Scene05Open(assets.coda.members[i + 1].slot);
  }
  if(guide03Scene05Cancelled(ctx)) return;
  guide03Scene01DrawLines(assets.coda, true);

  for(i = 0; i < assets.coda.autos.length; i++){
    await tl.wait(guide03Scene05AddAt(T.coda.autos[i], ctx));
    if(guide03Scene05Cancelled(ctx)) return;
    await guide03Scene05Reveal(assets.coda.autos[i]);
    guide03Scene01DrawLines(assets.coda, false);
  }

  await tl.wait(guide03Scene05AddAt(T.coda.note, ctx));
  if(guide03Scene05Cancelled(ctx)) return;
  await Promise.all([
    guide03Scene05Reveal(assets.coda.note),
    guide03Scene05Reveal(assets.coda.badge)
  ]);
}
</script>
