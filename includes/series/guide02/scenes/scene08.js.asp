<script>
var Guide02Scene08 = defineScene({
  id: Guide02Scene08Config.id,
  title: Guide02Scene08Config.title,
  duration: Guide02Scene08Config.duration,
  mediaSequence: Guide02Scene08Config.media.sequence,
  mediaFallbackMs: Guide02Scene08Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide02Scene08Config.panelCls);
    if(typeof Guide02Scene08Layout !== 'undefined') Guide02Scene08Layout.unbind();
    Guide02.resetScene(Guide02Scene08Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide02Scene08Config.panelCls);
    tl = Guide02.timeline(ctx);
    Guide02.resetScene(Guide02Scene08Config.canvasCls);
    Guide02.mountStage(canvas, Guide02Scene08Config.canvasCls);
    assets = setupGuide02Scene08(canvas);

    await Promise.all([
      runGuide02Scene08(tl, assets, ctx),
      Guide02.panelBulletTimeline(
        tl,
        Guide02Scene08Config.panel.title,
        Guide02Scene08Config.panel.bullets,
        guide02Scene08PanelFlashes(ctx)
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide02.finishSceneHold(tl, ctx.sceneDuration || Guide02Scene08Config.duration);
  }
});

function guide02Scene08Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function guide02Scene08Reveal(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g02-enter');
  if(typeof Guide02Scene08Layout !== 'undefined') Guide02Scene08Layout.schedule();
  await wait(420);
  el.classList.remove('g02-enter');
  el.classList.add('g02-idle');
}

function guide02Scene08EaseRow(row, mutate){
  var nodes = Array.prototype.slice.call(row.children);
  var before = nodes.map(function(n){
    var box = n.getBoundingClientRect();
    return { hidden: n.classList.contains('is-hidden'), left: box.left, top: box.top };
  });
  mutate();
  nodes.forEach(function(n, i){
    if(!before[i].hidden) n.classList.remove('g02-idle', 'g02-enter');
  });
  if(typeof Guide02Scene08Layout !== 'undefined') Guide02Scene08Layout.flush();
  var inner = row.closest ? row.closest('.g02-stack-inner') : null;
  var scale = 1;
  var moved = [];
  if(inner && inner.offsetWidth){
    scale = inner.getBoundingClientRect().width / inner.offsetWidth || 1;
  }
  nodes.forEach(function(n, i){
    if(before[i].hidden || !n.isConnected) return;
    var box = n.getBoundingClientRect();
    var dx = (before[i].left - box.left) / scale;
    var dy = (before[i].top - box.top) / scale;
    if(Math.abs(dx) < 0.4 && Math.abs(dy) < 0.4) return;
    n.style.transition = 'none';
    n.style.transform = 'translate(' + dx.toFixed(2) + 'px,' + dy.toFixed(2) + 'px)';
    moved.push(n);
  });
  void row.offsetWidth;
  moved.forEach(function(n){
    n.style.transition = 'transform 680ms ease-in-out';
    n.style.transform = 'translate(0px,0px)';
  });
  wait(700).then(function(){
    moved.forEach(function(n){
      if(!n.isConnected) return;
      n.style.transition = '';
      n.style.transform = '';
      n.classList.add('g02-idle');
    });
  });
}

async function runGuide02Scene08(tl, assets, ctx){
  var T = Guide02Scene08Config.T;
  var at = function(ms){ return guide02Scene08AtMain(ms, ctx); };

  await tl.wait(T.badge);
  if(guide02Scene08Cancelled(ctx)) return;
  await guide02Scene08Reveal(assets.badge);

  await tl.wait(at(T.panel));
  if(guide02Scene08Cancelled(ctx)) return;
  await guide02Scene08Reveal(assets.panel);

  await tl.wait(at(T.period));
  if(guide02Scene08Cancelled(ctx)) return;
  await guide02Scene08Reveal(assets.period);

  await tl.wait(at(T.nouvel));
  if(guide02Scene08Cancelled(ctx)) return;
  showElement(assets.row);
  await guide02Scene08Reveal(assets.nouvel);

  await tl.wait(at(T.signature));
  if(guide02Scene08Cancelled(ctx)) return;
  guide02Scene08EaseRow(assets.row, function(){
    showElement(assets.signature);
  });
  await guide02Scene08Reveal(assets.signature);

  await tl.wait(at(T.once));
  if(guide02Scene08Cancelled(ctx)) return;
  await guide02Scene08Reveal(assets.once);

  await tl.wait(at(T.price));
  if(guide02Scene08Cancelled(ctx)) return;
  await guide02Scene08Reveal(assets.price);

  await tl.wait(at(T.ep));
  if(guide02Scene08Cancelled(ctx)) return;
  await guide02Scene08Reveal(assets.ep);

  await tl.wait(at(T.points));
  if(guide02Scene08Cancelled(ctx)) return;
  await guide02Scene08Reveal(assets.points);
}
</script>
