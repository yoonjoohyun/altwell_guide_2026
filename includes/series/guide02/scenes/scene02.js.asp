<script>
var Guide02Scene02 = defineScene({
  id: Guide02Scene02Config.id,
  title: Guide02Scene02Config.title,
  duration: Guide02Scene02Config.duration,
  mediaSequence: Guide02Scene02Config.media.sequence,
  mediaFallbackMs: Guide02Scene02Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide02Scene02Config.panelCls);
    if(typeof Guide02Scene02Layout !== 'undefined') Guide02Scene02Layout.unbind();
    Guide02.resetScene(Guide02Scene02Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide02Scene02Config.panelCls);
    tl = Guide02.timeline(ctx);
    Guide02.resetScene(Guide02Scene02Config.canvasCls);
    Guide02.mountStage(canvas, Guide02Scene02Config.canvasCls);
    assets = setupGuide02Scene02(canvas);

    await Promise.all([
      runGuide02Scene02(tl, assets, ctx),
      Guide02.panelBulletTimeline(
        tl,
        Guide02Scene02Config.panel.title,
        Guide02Scene02Config.panel.bullets,
        guide02Scene02PanelFlashes()
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide02.finishSceneHold(tl, ctx.sceneDuration || Guide02Scene02Config.duration);
  }
});

function guide02Scene02Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function guide02Scene02Reveal(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g02-enter');
  if(typeof Guide02Scene02Layout !== 'undefined') Guide02Scene02Layout.schedule();
  await wait(420);
  el.classList.remove('g02-enter');
  el.classList.add('g02-idle');
}

async function runGuide02Scene02(tl, assets, ctx){
  var T = Guide02Scene02Config.T;
  var i;

  await tl.wait(T.member);
  if(guide02Scene02Cancelled(ctx)) return;
  await guide02Scene02Reveal(assets.member);

  await tl.wait(T.exclusive);
  if(guide02Scene02Cancelled(ctx)) return;
  await guide02Scene02Reveal(assets.exclusive);
  if(assets.exclusive){
    var exclusiveBadge = assets.exclusive.querySelector('.g02_exclusive_badge');
    if(exclusiveBadge) exclusiveBadge.classList.add('g02-emphasis');
  }

  await tl.wait(T.span);
  if(guide02Scene02Cancelled(ctx)) return;
  await guide02Scene02Reveal(assets.span);

  await tl.wait(T.period);
  if(guide02Scene02Cancelled(ctx)) return;
  await guide02Scene02Reveal(assets.box);

  for(i = 0; i < assets.months.length; i++){
    await tl.wait(T.months[i]);
    if(guide02Scene02Cancelled(ctx)) return;
    await guide02Scene02Reveal(assets.months[i].col);
  }

  await tl.wait(T.join);
  if(guide02Scene02Cancelled(ctx)) return;
  if(assets.months[0].card) assets.months[0].card.classList.add('is-on');
  await guide02Scene02Reveal(assets.join);

  for(i = 1; i < T.active.length; i++){
    await tl.wait(T.active[i]);
    if(guide02Scene02Cancelled(ctx)) return;
    if(assets.months[i].card) assets.months[i].card.classList.add('is-on');
  }

  await tl.wait(T.blocked);
  if(guide02Scene02Cancelled(ctx)) return;
  if(assets.months[3].card) assets.months[3].card.classList.add('is-off');
  await guide02Scene02Reveal(assets.blocked);
}
</script>
