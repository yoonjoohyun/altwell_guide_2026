<script>
var Guide04Scene06 = defineScene({
  id: Guide04Scene06Config.id,
  title: Guide04Scene06Config.title,
  duration: Guide04Scene06Config.duration,
  mediaSequence: Guide04Scene06Config.media.sequence,
  mediaFallbackMs: Guide04Scene06Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide04Scene06Config.panelCls);
    if(typeof Guide04Scene06Layout !== 'undefined') Guide04Scene06Layout.unbind();
    Guide04.resetScene(Guide04Scene06Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide04Scene06Config.panelCls);
    tl = Guide04.timeline(ctx);
    Guide04.resetScene(Guide04Scene06Config.canvasCls);
    Guide04.mountStage(canvas, Guide04Scene06Config.canvasCls);
    assets = setupGuide04Scene06(canvas);

    await Promise.all([
      runGuide04Scene06(tl, assets, ctx),
      Guide04.panelBulletTimeline(
        tl,
        Guide04Scene06Config.panel.title,
        Guide04Scene06Config.panel.bullets,
        Guide04Scene06Config.panel.flashes
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide04.finishSceneHold(tl, ctx.sceneDuration || Guide04Scene06Config.duration);
  }
});

function guide04Scene06Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function runGuide04Scene06(tl, assets, ctx){
  var T = Guide04Scene06Config.T;
  var ms = Guide04Scene06Config.motionMs;

  await tl.wait(T.panel);
  if(guide04Scene06Cancelled(ctx)) return;
  showElement(assets.wrap);
  assets.wrap.classList.add('is-in');
  if(typeof Guide04Scene06Layout !== 'undefined') Guide04Scene06Layout.schedule();
  await wait(ms);
  if(guide04Scene06Cancelled(ctx)) return;
  assets.wrap.classList.remove('is-in');
  assets.wrap.classList.add('is-idle');

  await tl.wait(T.title);
  if(guide04Scene06Cancelled(ctx)) return;
  GuideClosePanel.open(assets.titleSlot, { ms: ms, float: true });
  if(typeof Guide04Scene06Layout !== 'undefined') Guide04Scene06Layout.schedule();

  await tl.wait(T.sim);
  if(guide04Scene06Cancelled(ctx)) return;
  GuideClosePanel.open(assets.simSlot, { ms: ms, float: true });

  await tl.wait(T.replay);
  if(guide04Scene06Cancelled(ctx)) return;
  GuideClosePanel.open(assets.replaySlot, { ms: ms, float: true });
  await wait(ms);
  if(typeof Guide04Scene06Layout !== 'undefined') Guide04Scene06Layout.flush();
}
</script>
