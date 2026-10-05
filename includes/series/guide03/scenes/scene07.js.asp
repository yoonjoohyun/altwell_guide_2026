<script>
var Guide03Scene07 = defineScene({
  id: Guide03Scene07Config.id,
  title: Guide03Scene07Config.title,
  duration: Guide03Scene07Config.duration,
  mediaSequence: Guide03Scene07Config.media.sequence,
  mediaFallbackMs: Guide03Scene07Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide03Scene07Config.panelCls);
    if(typeof Guide03Scene07Layout !== 'undefined') Guide03Scene07Layout.unbind();
    Guide03.resetScene(Guide03Scene07Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide03Scene07Config.panelCls);
    tl = Guide03.timeline(ctx);
    Guide03.resetScene(Guide03Scene07Config.canvasCls);
    Guide03.mountStage(canvas, Guide03Scene07Config.canvasCls);
    assets = setupGuide03Scene07(canvas);

    await Promise.all([
      runGuide03Scene07(tl, assets, ctx),
      Guide03.panelBulletTimeline(
        tl,
        Guide03Scene07Config.panel.title,
        Guide03Scene07Config.panel.bullets,
        guide03Scene07PanelFlashes(ctx)
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide03.finishSceneHold(tl, ctx.sceneDuration || Guide03Scene07Config.duration);
  }
});

function guide03Scene07Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

function guide03Scene07Fit(){
  if(typeof Guide03Scene07Layout !== 'undefined') Guide03Scene07Layout.schedule();
}

async function guide03Scene07Reveal(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g03-enter');
  guide03Scene07Fit();
  await wait(760);
  el.classList.remove('g03-enter');
}

async function guide03Scene07Swap(host, fromEl, toEl){
  if(!host || !fromEl || !toEl) return;
  host.classList.add('is-jump');
  await wait(260);
  hideElement(fromEl);
  showElement(toEl);
  await wait(420);
  host.classList.remove('is-jump');
}

async function runGuide03Scene07(tl, assets, ctx){
  var T = Guide03Scene07Config.T;
  var at = function(ms){ return guide03Scene07AtMain(ms, ctx); };
  var mixed = assets.mixed;
  var pair = assets.pair;
  var i;

  await tl.wait(T.badge);
  if(guide03Scene07Cancelled(ctx)) return;
  await guide03Scene01UnfoldChip(assets.badge);
  guide03Scene07Fit();

  await tl.wait(at(T.board));
  if(guide03Scene07Cancelled(ctx)) return;
  await guide03Scene07Reveal(mixed.board);

  for(i = 0; i < 2; i++){
    await tl.wait(at(T.partners[i]));
    if(guide03Scene07Cancelled(ctx)) return;
    await guide03Scene07Reveal(i === 0 ? mixed.left.wrap : mixed.right.wrap);
  }

  await tl.wait(at(T.mixed[0]));
  if(guide03Scene07Cancelled(ctx)) return;
  await guide03Scene07Reveal(mixed.left.chips.auto);

  await tl.wait(at(T.mixed[1]));
  if(guide03Scene07Cancelled(ctx)) return;
  await guide03Scene07Reveal(mixed.right.chips.sep);

  await tl.wait(at(T.ban));
  if(guide03Scene07Cancelled(ctx)) return;
  mixed.board.classList.add('is-muted');
  await guide03Scene07Reveal(mixed.ban);

  await tl.wait(at(T.clear));
  if(guide03Scene07Cancelled(ctx)) return;
  hideElement(mixed.ban);
  mixed.board.classList.remove('is-muted');

  await tl.wait(at(T.toAuto));
  if(guide03Scene07Cancelled(ctx)) return;
  await guide03Scene07Swap(mixed.right.host, mixed.right.chips.sep, mixed.right.chips.auto);

  await tl.wait(at(T.checkA));
  if(guide03Scene07Cancelled(ctx)) return;
  await guide03Scene07Reveal(mixed.check);

  await tl.wait(at(T.clone));
  if(guide03Scene07Cancelled(ctx)) return;
  await guide03Scene07Reveal(pair.card);

  await tl.wait(at(T.toSep));
  if(guide03Scene07Cancelled(ctx)) return;
  await Promise.all([
    guide03Scene07Swap(pair.left.host, pair.left.chips.auto, pair.left.chips.sep),
    guide03Scene07Swap(pair.right.host, pair.right.chips.auto, pair.right.chips.sep)
  ]);

  await tl.wait(at(T.checkB));
  if(guide03Scene07Cancelled(ctx)) return;
  await guide03Scene07Reveal(pair.check);
}
</script>
