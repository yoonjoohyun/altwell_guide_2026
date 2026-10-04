<script>
var Guide03Scene02 = defineScene({
  id: Guide03Scene02Config.id,
  title: Guide03Scene02Config.title,
  duration: Guide03Scene02Config.duration,
  mediaSequence: Guide03Scene02Config.media.sequence,
  mediaFallbackMs: Guide03Scene02Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide03Scene02Config.panelCls);
    if(typeof Guide03Scene02Layout !== 'undefined') Guide03Scene02Layout.unbind();
    Guide03.resetScene(Guide03Scene02Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide03Scene02Config.panelCls);
    tl = Guide03.timeline(ctx);
    Guide03.resetScene(Guide03Scene02Config.canvasCls);
    Guide03.mountStage(canvas, Guide03Scene02Config.canvasCls);
    assets = setupGuide03Scene02(canvas);

    await Promise.all([
      runGuide03Scene02(tl, assets, ctx),
      Guide03.panelBulletTimeline(
        tl,
        Guide03Scene02Config.panel.title,
        Guide03Scene02Config.panel.bullets,
        guide03Scene02PanelFlashes(ctx)
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide03.finishSceneHold(tl, ctx.sceneDuration || Guide03Scene02Config.duration);
  }
});

function guide03Scene02Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function guide03Scene02Reveal(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g03-enter');
  if(typeof Guide03Scene02Layout !== 'undefined') Guide03Scene02Layout.schedule();
  await wait(760);
  el.classList.remove('g03-enter');
}

async function guide03Scene02Open(slot){
  if(!slot) return;
  slot.classList.add('is-open');
  if(typeof Guide03Scene02Layout !== 'undefined') Guide03Scene02Layout.schedule();
  await wait(740);
}

async function guide03Scene02FoldBadge(wrap){
  var badge = wrap && wrap.querySelector('.base_business_icon_o');
  var track = badge && badge.querySelector('.g03-fold-track');
  var text = badge && badge.querySelector('.base_text');
  if(!track || !text) return;
  text.style.transition = 'opacity 280ms cubic-bezier(.25,.1,.25,1)';
  track.style.transition = 'max-width 640ms cubic-bezier(.22,1,.36,1)';
  text.style.opacity = '0';
  await wait(140);
  track.style.maxWidth = '0px';
  await wait(660);
}

async function guide03Scene02MoveBadge(assets){
  var badge = assets.badge;
  var dock = assets.dock;
  var qual = assets.qual;
  var inner = assets.inner;
  var scale = 1;
  var first;
  var last;
  var qualFirst;
  var qualLast;
  if(!badge || !dock) return;
  if(inner && inner.offsetWidth){
    scale = inner.getBoundingClientRect().width / inner.offsetWidth || 1;
  }
  first = badge.getBoundingClientRect();
  qualFirst = qual ? qual.getBoundingClientRect() : null;
  dock.appendChild(badge);
  badge.classList.add('is-docked');
  last = badge.getBoundingClientRect();
  badge.style.transition = 'none';
  badge.style.transformOrigin = 'left bottom';
  badge.style.transform = 'translate(' + ((first.left - last.left) / scale) + 'px,' + ((first.top - last.top) / scale) + 'px) scale(1)';
  if(qual && qualFirst){
    qualLast = qual.getBoundingClientRect();
    qual.style.transition = 'none';
    qual.style.transform = 'translate(' + ((qualFirst.left - qualLast.left) / scale) + 'px,' + ((qualFirst.top - qualLast.top) / scale) + 'px)';
  }
  badge.getBoundingClientRect();
  await wait(40);
  badge.style.transition = 'transform 780ms cubic-bezier(.16,1,.3,1)';
  badge.style.transform = 'translate(0,0) scale(0.82)';
  if(qual){
    qual.style.transition = 'transform 780ms cubic-bezier(.16,1,.3,1)';
    qual.style.transform = 'translate(0,0)';
  }
  await wait(800);
  if(typeof Guide03Scene02Layout !== 'undefined') Guide03Scene02Layout.schedule();
}

async function runGuide03Scene02(tl, assets, ctx){
  var T = Guide03Scene02Config.T;
  var at = function(ms){ return guide03Scene02AtMain(ms, ctx); };
  var i;

  await tl.wait(T.board);
  if(guide03Scene02Cancelled(ctx)) return;
  await guide03Scene02Reveal(assets.board);

  await tl.wait(T.caption);
  if(guide03Scene02Cancelled(ctx)) return;
  await guide03Scene02Open(assets.caption);

  for(i = 0; i < assets.members.length; i++){
    await tl.wait(at(T.members[i]));
    if(guide03Scene02Cancelled(ctx)) return;
    await guide03Scene02Open(assets.members[i].member);
  }
  if(guide03Scene02Cancelled(ctx)) return;
  guide03Scene01DrawLines(assets, true);

  await tl.wait(at(T.badge));
  if(guide03Scene02Cancelled(ctx)) return;
  await guide03Scene01UnfoldChip(assets.badge);
  if(typeof Guide03Scene02Layout !== 'undefined') Guide03Scene02Layout.schedule();

  await tl.wait(at(T.fold));
  if(guide03Scene02Cancelled(ctx)) return;
  await Promise.all([
    guide03Scene02FoldBadge(assets.badge),
    guide03Scene02Reveal(assets.qual)
  ]);

  for(i = 1; i < assets.members.length; i++){
    await tl.wait(at(T.checks[i - 1]));
    if(guide03Scene02Cancelled(ctx)) return;
    await guide03Scene02Open(assets.members[i].check);
    guide03Scene01DrawLines(assets, false);
  }

  await tl.wait(at(T.selfCheck));
  if(guide03Scene02Cancelled(ctx)) return;
  await guide03Scene02Open(assets.members[0].check);
  guide03Scene01DrawLines(assets, false);

  await tl.wait(at(T.move));
  if(guide03Scene02Cancelled(ctx)) return;
  await guide03Scene02MoveBadge(assets);

  await tl.wait(at(T.month));
  if(guide03Scene02Cancelled(ctx)) return;
  await guide03Scene02Reveal(assets.month);
}
</script>
