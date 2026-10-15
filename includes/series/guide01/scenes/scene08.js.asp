<script>
var Guide01Scene08 = defineScene({
  id: Scene08Config.id,
  title: Scene08Config.title,
  duration: Scene08Config.duration,
  mediaSequence: Scene08Config.media.sequence,
  mediaFallbackMs: Scene08Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Scene08Config.panelCls);
    if(typeof Scene08Layout !== 'undefined') Scene08Layout.unbind();
    Guide01.resetScene(Scene08Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Scene08Config.panelCls);
    tl = Guide01.timeline(ctx);
    Guide01.resetScene(Scene08Config.canvasCls);
    Guide01.mountStage(canvas, Scene08Config.canvasCls);
    assets = setupScene08Assets(canvas);

    await Promise.all([
      runScene08Motion(tl, assets, ctx),
      Guide01.panelBulletTimeline(
        tl,
        Scene08Config.panel.title,
        Scene08Config.panel.bullets,
        Scene08Config.panel.flashes
      )
    ]);
    if(scene08Cancelled(ctx)) return;
    await Guide01.finishSceneHold(tl, ctx.sceneDuration || Scene08Config.duration);
  }
});

function scene08Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function runScene08Motion(tl, assets, ctx){
  var T = Scene08Config.T;
  var ms = Scene08Config.motionMs;

  await tl.wait(T.panel);
  if(scene08Cancelled(ctx)) return;
  showElement(assets.wrap);
  assets.wrap.classList.add('is-in');
  if(typeof Scene08Layout !== 'undefined') Scene08Layout.schedule();
  await wait(ms);
  if(scene08Cancelled(ctx)) return;
  assets.wrap.classList.remove('is-in');
  assets.wrap.classList.add('is-idle');

  await tl.wait(T.title);
  if(scene08Cancelled(ctx)) return;
  GuideClosePanel.open(assets.titleSlot, { ms: ms, float: true });
  if(typeof Scene08Layout !== 'undefined') Scene08Layout.schedule();

  await tl.wait(T.sim);
  if(scene08Cancelled(ctx)) return;
  GuideClosePanel.open(assets.simSlot, { ms: ms, float: true });

  await tl.wait(T.replay);
  if(scene08Cancelled(ctx)) return;
  GuideClosePanel.open(assets.replaySlot, { ms: ms, float: true });
  await wait(ms);
  if(typeof Scene08Layout !== 'undefined') Scene08Layout.flush();
}
</script>
