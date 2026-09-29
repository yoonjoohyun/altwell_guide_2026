<script>
var Guide02Scene04 = defineScene({
  id: Guide02Scene04Config.id,
  title: Guide02Scene04Config.title,
  duration: Guide02Scene04Config.duration,
  mediaSequence: Guide02Scene04Config.media.sequence,
  mediaFallbackMs: Guide02Scene04Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide02Scene04Config.panelCls);
    if(typeof Guide02Scene04Layout !== 'undefined') Guide02Scene04Layout.unbind();
    Guide02.resetScene(Guide02Scene04Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide02Scene04Config.panelCls);
    tl = Guide02.timeline(ctx);
    Guide02.resetScene(Guide02Scene04Config.canvasCls);
    Guide02.mountStage(canvas, Guide02Scene04Config.canvasCls);
    assets = setupGuide02Scene04(canvas);

    await Promise.all([
      runGuide02Scene04(tl, assets, ctx),
      Guide02.panelBulletTimeline(
        tl,
        Guide02Scene04Config.panel.title,
        Guide02Scene04Config.panel.bullets,
        guide02Scene04PanelFlashes()
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide02.finishSceneHold(tl, ctx.sceneDuration || Guide02Scene04Config.duration);
  }
});

function guide02Scene04Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function guide02Scene04Reveal(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g02-enter');
  if(typeof Guide02Scene04Layout !== 'undefined') Guide02Scene04Layout.schedule();
  await wait(760);
  el.classList.remove('g02-enter');
  el.classList.add('g02-idle');
}

async function runGuide02Scene04(tl, assets, ctx){
  var T = Guide02Scene04Config.T;
  var i;

  await tl.wait(T.badge);
  if(guide02Scene04Cancelled(ctx)) return;
  await guide02Scene04Reveal(assets.badge);

  await tl.wait(T.fold);
  if(guide02Scene04Cancelled(ctx)) return;
  if(assets.badgeRoot){
    var badge = assets.badgeRoot;
    badge.style.width = badge.offsetWidth + 'px';
    badge.style.height = badge.offsetHeight + 'px';
    badge.classList.add('is-folding');
    await wait(480);
    if(guide02Scene04Cancelled(ctx)) return;
    badge.classList.add('is-folded');
    badge.style.width = '48px';
    badge.style.height = '48px';
  }
  await guide02Scene04Reveal(assets.summary);

  for(i = 0; i < T.rows.length; i++){
    await tl.wait(T.rows[i]);
    if(guide02Scene04Cancelled(ctx)) return;
    if(assets.rows[i]) assets.rows[i].classList.add('is-visible');
    if(typeof Guide02Scene04Layout !== 'undefined') Guide02Scene04Layout.schedule();
  }

  await tl.wait(T.bundle);
  if(guide02Scene04Cancelled(ctx)) return;
  await guide02Scene04Reveal(assets.bundle);

  for(i = 0; i < T.bundleLines.length; i++){
    await tl.wait(T.bundleLines[i]);
    if(guide02Scene04Cancelled(ctx)) return;
    if(assets.bundleLines[i]) assets.bundleLines[i].classList.add('is-visible');
    if(typeof Guide02Scene04Layout !== 'undefined') Guide02Scene04Layout.schedule();
  }

  await tl.wait(T.coinA);
  if(guide02Scene04Cancelled(ctx)) return;
  await guide02Scene04Reveal(assets.ep);
  showElement(assets.coinA);

  await tl.wait(T.coinB);
  if(guide02Scene04Cancelled(ctx)) return;
  if(assets.coins) assets.coins.classList.add('is-pair');
  showElement(assets.coinB);

  await tl.wait(T.coinMerge);
  if(guide02Scene04Cancelled(ctx)) return;
  showElement(assets.coinSum);
  await wait(40);
  if(assets.coins) assets.coins.classList.add('is-merge');
  if(typeof Guide02Scene04Layout !== 'undefined') Guide02Scene04Layout.schedule();
}
</script>
