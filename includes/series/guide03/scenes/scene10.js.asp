<script>
var Guide03Scene10 = defineScene({
  id: Guide03Scene10Config.id,
  title: Guide03Scene10Config.title,
  duration: Guide03Scene10Config.duration,
  mediaSequence: Guide03Scene10Config.media.sequence,
  mediaFallbackMs: Guide03Scene10Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide03Scene10Config.panelCls);
    if(typeof Guide03Scene10Layout !== 'undefined') Guide03Scene10Layout.unbind();
    Guide03.resetScene(Guide03Scene10Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide03Scene10Config.panelCls);
    tl = Guide03.timeline(ctx);
    Guide03.resetScene(Guide03Scene10Config.canvasCls);
    Guide03.mountStage(canvas, Guide03Scene10Config.canvasCls);
    assets = setupGuide03Scene10(canvas);

    await Promise.all([
      runGuide03Scene10(tl, assets, ctx),
      Guide03.panelBulletTimeline(
        tl,
        Guide03Scene10Config.panel.title,
        Guide03Scene10Config.panel.bullets,
        guide03Scene10PanelFlashes(ctx)
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide03.finishSceneHold(tl, ctx.sceneDuration || Guide03Scene10Config.duration);
  }
});

function guide03Scene10Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function guide03Scene10Place(root, host, floater, mutate){
  var inner = root && root.closest ? root.closest('.g03-stack-inner') : null;
  var nodes = root ? root.querySelectorAll('.g03-s10-shift') : [];
  var before = [];
  var scale = 1;
  var i;
  var box;
  var dx;
  var dy;
  for(i = 0; i < nodes.length; i++){
    if(nodes[i].classList.contains('is-hidden')) continue;
    box = nodes[i].getBoundingClientRect();
    if(box.width < 2 && box.height < 2) continue;
    before.push({ el: nodes[i], left: box.left, top: box.top });
  }
  if(mutate) mutate();
  if(host) showElement(host);
  if(floater) floater.classList.add('g03-enter');
  if(typeof Guide03Scene10Layout !== 'undefined') Guide03Scene10Layout.flush();
  if(inner && inner.offsetWidth){
    scale = inner.getBoundingClientRect().width / inner.offsetWidth || 1;
  }
  for(i = 0; i < before.length; i++){
    box = before[i].el.getBoundingClientRect();
    dx = (before[i].left - box.left) / scale;
    dy = (before[i].top - box.top) / scale;
    before[i].dx = dx;
    before[i].dy = dy;
    if(Math.abs(dx) < 0.4 && Math.abs(dy) < 0.4) continue;
    before[i].el.style.transition = 'none';
    before[i].el.style.transform = 'translate(' + dx + 'px,' + dy + 'px)';
  }
  if(root) void root.offsetWidth;
  for(i = 0; i < before.length; i++){
    if(Math.abs(before[i].dx) < 0.4 && Math.abs(before[i].dy) < 0.4) continue;
    before[i].el.style.transition = 'transform 760ms cubic-bezier(.16,1,.3,1)';
    before[i].el.style.transform = 'translate(0,0)';
  }
  if(typeof Guide03Scene10Layout !== 'undefined') Guide03Scene10Layout.schedule();
  await wait(760);
  if(floater) floater.classList.remove('g03-enter');
}

async function guide03Scene10HideBadge(wrap){
  if(typeof guide03Scene02FoldBadge === 'function') await guide03Scene02FoldBadge(wrap);
  if(!wrap) return;
  wrap.style.transition = 'opacity 420ms ease';
  wrap.style.opacity = '0';
  await wait(420);
  hideElement(wrap);
}

async function runGuide03Scene10(tl, assets, ctx){
  var T = Guide03Scene10Config.T;
  var at = function(ms){ return guide03Scene10AtMain(ms, ctx); };

  await tl.wait(T.badge);
  if(guide03Scene10Cancelled(ctx)) return;
  showElement(assets.badge);
  assets.badge.classList.add('g03-enter');
  if(typeof guide03Scene01UnfoldChip === 'function'){
    guide03Scene01UnfoldChip(assets.badge);
  }
  if(typeof Guide03Scene10Layout !== 'undefined') Guide03Scene10Layout.schedule();

  await tl.wait(T.badgeFold);
  if(guide03Scene10Cancelled(ctx)) return;
  assets.badge.classList.remove('g03-enter');
  await guide03Scene10HideBadge(assets.badge);

  await tl.wait(at(T.self));
  if(guide03Scene10Cancelled(ctx)) return;
  await guide03Scene10Place(assets.stage, assets.self.host, assets.self.icon);

  await tl.wait(at(T.selfAuto));
  if(guide03Scene10Cancelled(ctx)) return;
  await guide03Scene10Place(assets.stage, assets.selfAuto, assets.selfAuto);

  await tl.wait(at(T.selfSep));
  if(guide03Scene10Cancelled(ctx)) return;
  await guide03Scene10Place(assets.stage, assets.selfSep, assets.selfSep);

  await tl.wait(at(T.partners[0]));
  if(guide03Scene10Cancelled(ctx)) return;
  await guide03Scene10Place(assets.stage, assets.partners[0].host, assets.partners[0].icon);

  await tl.wait(at(T.partners[1]));
  if(guide03Scene10Cancelled(ctx)) return;
  await guide03Scene10Place(assets.stage, assets.partners[1].host, assets.partners[1].icon);

  await tl.wait(at(T.partnerAuto));
  if(guide03Scene10Cancelled(ctx)) return;
  await guide03Scene10Place(assets.stage, assets.partnerAuto, assets.partnerAuto);

  await tl.wait(at(T.or));
  if(guide03Scene10Cancelled(ctx)) return;
  await guide03Scene10Place(assets.stage, assets.or, assets.or);

  await tl.wait(at(T.partnerSep));
  if(guide03Scene10Cancelled(ctx)) return;
  await guide03Scene10Place(assets.stage, assets.partnerSep, assets.partnerSep);

  await tl.wait(at(T.card));
  if(guide03Scene10Cancelled(ctx)) return;
  await guide03Scene10Place(assets.stage, assets.caption, assets.caption, function(){
    assets.card.classList.add('is-on');
  });

  await tl.wait(at(T.orb1));
  if(guide03Scene10Cancelled(ctx)) return;
  await guide03Scene10Place(assets.stage, assets.orbs[0], assets.orbs[0]);

  await tl.wait(at(T.orb2));
  if(guide03Scene10Cancelled(ctx)) return;
  await guide03Scene10Place(assets.stage, assets.orbs[1], assets.orbs[1]);

  await tl.wait(at(T.orb3));
  if(guide03Scene10Cancelled(ctx)) return;
  await guide03Scene10Place(assets.stage, assets.orbs[2], assets.orbs[2]);
}
</script>
