<script>
var Guide02Scene03 = defineScene({
  id: Guide02Scene03Config.id,
  title: Guide02Scene03Config.title,
  duration: Guide02Scene03Config.duration,
  mediaSequence: Guide02Scene03Config.media.sequence,
  mediaFallbackMs: Guide02Scene03Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide02Scene03Config.panelCls);
    if(typeof Guide02Scene03Layout !== 'undefined') Guide02Scene03Layout.unbind();
    Guide02.resetScene(Guide02Scene03Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide02Scene03Config.panelCls);
    tl = Guide02.timeline(ctx);
    Guide02.resetScene(Guide02Scene03Config.canvasCls);
    Guide02.mountStage(canvas, Guide02Scene03Config.canvasCls);
    assets = setupGuide02Scene03(canvas);

    await Promise.all([
      runGuide02Scene03(tl, assets, ctx),
      Guide02.panelBulletTimeline(
        tl,
        Guide02Scene03Config.panel.title,
        Guide02Scene03Config.panel.bullets,
        guide02Scene03PanelFlashes()
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide02.finishSceneHold(tl, ctx.sceneDuration || Guide02Scene03Config.duration);
  }
});

function guide02Scene03Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function guide02Scene03Reveal(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g02-enter');
  if(typeof Guide02Scene03Layout !== 'undefined') Guide02Scene03Layout.schedule();
  await wait(420);
  el.classList.remove('g02-enter');
  el.classList.add('g02-idle');
}

async function runGuide02Scene03(tl, assets, ctx){
  var T = Guide02Scene03Config.T;

  await tl.wait(T.badge);
  if(guide02Scene03Cancelled(ctx)) return;
  await guide02Scene03Reveal(assets.badge);

  await tl.wait(T.nouvel);
  if(guide02Scene03Cancelled(ctx)) return;
  await guide02Scene03Reveal(assets.nouvel);

  await tl.wait(T.nouvelIcon);
  if(guide02Scene03Cancelled(ctx)) return;
  await guide02Scene03Reveal(assets.nouvelIcon);

  await tl.wait(T.signature);
  if(guide02Scene03Cancelled(ctx)) return;
  await guide02Scene03Reveal(assets.signature);

  await tl.wait(T.signatureIcon);
  if(guide02Scene03Cancelled(ctx)) return;
  await guide02Scene03Reveal(assets.signatureIcon);

  await tl.wait(T.once);
  if(guide02Scene03Cancelled(ctx)) return;
  await Promise.all([
    guide02Scene03Reveal(assets.onceNouvel),
    guide02Scene03Reveal(assets.onceSignature)
  ]);
}
</script>
