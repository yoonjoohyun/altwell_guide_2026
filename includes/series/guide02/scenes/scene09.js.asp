<script>
var Guide02Scene09 = defineScene({
  id: Guide02Scene09Config.id,
  title: Guide02Scene09Config.title,
  duration: Guide02Scene09Config.duration,
  mediaSequence: Guide02Scene09Config.media.sequence,
  mediaFallbackMs: Guide02Scene09Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide02Scene09Config.panelCls);
    if(typeof Guide02Scene09Layout !== 'undefined') Guide02Scene09Layout.unbind();
    Guide02.resetScene(Guide02Scene09Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide02Scene09Config.panelCls);
    tl = Guide02.timeline(ctx);
    Guide02.resetScene(Guide02Scene09Config.canvasCls);
    Guide02.mountStage(canvas, Guide02Scene09Config.canvasCls);
    assets = setupGuide02Scene09(canvas);

    await Promise.all([
      runGuide02Scene09(tl, assets, ctx),
      Guide02.panelBulletTimeline(
        tl,
        Guide02Scene09Config.panel.title,
        Guide02Scene09Config.panel.bullets,
        Guide02Scene09Config.panel.flashes
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide02.finishSceneHold(tl, ctx.sceneDuration || Guide02Scene09Config.duration);
  }
});

function guide02Scene09Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function runGuide02Scene09(tl, assets, ctx){
  var T = Guide02Scene09Config.T;
  var ms = Guide02Scene09Config.motionMs;

  await tl.wait(T.panel);
  if(guide02Scene09Cancelled(ctx)) return;
  showElement(assets.wrap);
  assets.wrap.classList.add('is-in');
  if(typeof Guide02Scene09Layout !== 'undefined') Guide02Scene09Layout.schedule();
  await wait(ms);
  if(guide02Scene09Cancelled(ctx)) return;
  assets.wrap.classList.remove('is-in');
  assets.wrap.classList.add('is-idle');

  await tl.wait(T.title);
  if(guide02Scene09Cancelled(ctx)) return;
  GuideClosePanel.open(assets.titleSlot, { ms: ms, float: true });
  if(typeof Guide02Scene09Layout !== 'undefined') Guide02Scene09Layout.schedule();

  await tl.wait(T.sim);
  if(guide02Scene09Cancelled(ctx)) return;
  GuideClosePanel.open(assets.simSlot, { ms: ms, float: true });

  await tl.wait(T.replay);
  if(guide02Scene09Cancelled(ctx)) return;
  GuideClosePanel.open(assets.replaySlot, { ms: ms, float: true });
  await wait(ms);
  if(typeof Guide02Scene09Layout !== 'undefined') Guide02Scene09Layout.flush();
}
</script>
