<script>
var Guide02Scene01 = defineScene({
  id: Guide02Scene01Config.id,
  title: Guide02Scene01Config.title,
  duration: Guide02Scene01Config.duration,
  mediaSequence: Guide02Scene01Config.media.sequence,
  mediaFallbackMs: Guide02Scene01Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide02Scene01Config.panelCls);
    if(typeof Guide02Scene01Layout !== 'undefined') Guide02Scene01Layout.unbind();
    Guide02.resetScene(Guide02Scene01Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide02Scene01Config.panelCls);
    tl = Guide02.timeline(ctx);
    Guide02.resetScene(Guide02Scene01Config.canvasCls);
    Guide02.mountStage(canvas, Guide02Scene01Config.canvasCls);
    assets = setupGuide02Scene01(canvas);

    await Promise.all([
      runGuide02Scene01(tl, assets, ctx),
      Guide02.panelBulletTimeline(
        tl,
        Guide02Scene01Config.panel.title,
        Guide02Scene01Config.panel.bullets,
        guide02Scene01PanelFlashes()
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide02.finishSceneHold(tl, ctx.sceneDuration || Guide02Scene01Config.duration);
  }
});

function guide02Scene01Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function guide02Reveal(el, col){
  if(!el) return;
  if(col) showElement(col);
  showElement(el);
  el.classList.add('g02-enter');
  if(typeof Guide02Scene01Layout !== 'undefined') Guide02Scene01Layout.schedule();
  await wait(420);
  el.classList.remove('g02-enter');
  el.classList.add('g02-idle');
}

async function runGuide02Scene01(tl, assets, ctx){
  var T = Guide02Scene01Config.T;

  await tl.wait(T.member);
  if(guide02Scene01Cancelled(ctx)) return;
  await Promise.all([
    guide02Reveal(assets.member),
    guide02Reveal(assets.badge)
  ]);

  await tl.wait(T.nouvel);
  if(guide02Scene01Cancelled(ctx)) return;
  await guide02Reveal(assets.nouvel, assets.colLeft);

  await tl.wait(T.signature);
  if(guide02Scene01Cancelled(ctx)) return;
  await guide02Reveal(assets.signature, assets.colRight);

  await tl.wait(T.exclusive);
  if(guide02Scene01Cancelled(ctx)) return;
  if(assets.badgeSub){
    showElement(assets.badgeSub);
    assets.badgeSub.classList.add('g02-enter');
    if(typeof Guide02Scene01Layout !== 'undefined') Guide02Scene01Layout.schedule();
    await wait(420);
    assets.badgeSub.classList.remove('g02-enter');
  }

  await tl.wait(T.discount);
  if(guide02Scene01Cancelled(ctx)) return;
  await guide02Reveal(assets.discount);

  await tl.wait(T.experience);
  if(guide02Scene01Cancelled(ctx)) return;
  await guide02Reveal(assets.experience, assets.colLeft);

  await tl.wait(T.launch);
  if(guide02Scene01Cancelled(ctx)) return;
  await guide02Reveal(assets.launch, assets.colRight);
}
</script>
