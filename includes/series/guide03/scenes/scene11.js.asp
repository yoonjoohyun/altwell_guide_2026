<script>
var Guide03Scene11 = defineScene({
  id: Guide03Scene11Config.id,
  title: Guide03Scene11Config.title,
  duration: Guide03Scene11Config.duration,
  mediaSequence: Guide03Scene11Config.media.sequence,
  mediaFallbackMs: Guide03Scene11Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide03Scene11Config.panelCls);
    if(typeof Guide03Scene11Layout !== 'undefined') Guide03Scene11Layout.unbind();
    Guide03.resetScene(Guide03Scene11Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide03Scene11Config.panelCls);
    tl = Guide03.timeline(ctx);
    Guide03.resetScene(Guide03Scene11Config.canvasCls);
    Guide03.mountStage(canvas, Guide03Scene11Config.canvasCls);
    assets = setupGuide03Scene11(canvas);

    await Promise.all([
      runGuide03Scene11(tl, assets, ctx),
      Guide03.panelBulletTimeline(
        tl,
        Guide03Scene11Config.panel.title,
        Guide03Scene11Config.panel.bullets,
        Guide03Scene11Config.panel.flashes
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide03.finishSceneHold(tl, ctx.sceneDuration || Guide03Scene11Config.duration);
  }
});

function guide03Scene11Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function runGuide03Scene11(tl, assets, ctx){
  var T = Guide03Scene11Config.T;
  var ms = Guide03Scene11Config.motionMs;

  await tl.wait(T.panel);
  if(guide03Scene11Cancelled(ctx)) return;
  showElement(assets.wrap);
  assets.wrap.classList.add('is-in');
  if(typeof Guide03Scene11Layout !== 'undefined') Guide03Scene11Layout.schedule();
  await wait(ms);
  if(guide03Scene11Cancelled(ctx)) return;
  assets.wrap.classList.remove('is-in');
  assets.wrap.classList.add('is-idle');

  await tl.wait(T.title);
  if(guide03Scene11Cancelled(ctx)) return;
  GuideClosePanel.open(assets.titleSlot, { ms: ms, float: true });
  if(typeof Guide03Scene11Layout !== 'undefined') Guide03Scene11Layout.schedule();

  await tl.wait(T.sim);
  if(guide03Scene11Cancelled(ctx)) return;
  GuideClosePanel.open(assets.simSlot, { ms: ms, float: true });

  await tl.wait(T.replay);
  if(guide03Scene11Cancelled(ctx)) return;
  GuideClosePanel.open(assets.replaySlot, { ms: ms, float: true });
  await wait(ms);
  if(typeof Guide03Scene11Layout !== 'undefined') Guide03Scene11Layout.flush();
}
</script>
