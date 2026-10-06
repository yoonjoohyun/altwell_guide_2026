<script>
var Guide03Scene09 = defineScene({
  id: Guide03Scene09Config.id,
  title: Guide03Scene09Config.title,
  duration: Guide03Scene09Config.duration,
  mediaSequence: Guide03Scene09Config.media.sequence,
  mediaFallbackMs: Guide03Scene09Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide03Scene09Config.panelCls);
    if(typeof Guide03Scene09Layout !== 'undefined') Guide03Scene09Layout.unbind();
    Guide03.resetScene(Guide03Scene09Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide03Scene09Config.panelCls);
    tl = Guide03.timeline(ctx);
    Guide03.resetScene(Guide03Scene09Config.canvasCls);
    Guide03.mountStage(canvas, Guide03Scene09Config.canvasCls);
    assets = setupGuide03Scene09(canvas);

    await Promise.all([
      runGuide03Scene09(tl, assets, ctx),
      Guide03.panelBulletTimeline(
        tl,
        Guide03Scene09Config.panel.title,
        Guide03Scene09Config.panel.bullets,
        guide03Scene09PanelFlashes(ctx)
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide03.finishSceneHold(tl, ctx.sceneDuration || Guide03Scene09Config.duration);
  }
});

function guide03Scene09Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function guide03Scene09Reveal(assets, nodes){
  var tree = assets && assets.tree;
  var inner = tree && tree.closest ? tree.closest('.g03-stack-inner') : null;
  var shown;
  var before = [];
  var scale = 1;
  var i;
  var box;
  var dx;
  var dy;
  if(!nodes || !nodes.length || !tree) return;
  shown = tree.querySelectorAll('.g03-s09-col.is-shown');
  for(i = 0; i < shown.length; i++){
    box = shown[i].getBoundingClientRect();
    before.push({ el: shown[i], left: box.left, top: box.top });
  }
  for(i = 0; i < nodes.length; i++){
    nodes[i].col.classList.add('is-shown');
    nodes[i].grow.classList.add('is-open');
    if(nodes[i].icon){
      nodes[i].icon.innerHTML = '';
      nodes[i].icon.classList.add('g03-enter');
    }
  }
  if(typeof Guide03Scene09Layout !== 'undefined') Guide03Scene09Layout.flush();
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
  void tree.offsetWidth;
  for(i = 0; i < before.length; i++){
    if(Math.abs(before[i].dx) < 0.4 && Math.abs(before[i].dy) < 0.4) continue;
    before[i].el.style.transition = 'transform 760ms cubic-bezier(.16,1,.3,1)';
    before[i].el.style.transform = 'translate(0,0)';
  }
  guide03Scene09Track(assets, 760);
  await wait(760);
  for(i = 0; i < nodes.length; i++){
    if(nodes[i].icon) nodes[i].icon.classList.remove('g03-enter');
  }
  guide03Scene09Draw(assets, false);
}

async function guide03Scene09JumpToSelf(icon){
  var badge;
  if(!icon) return;
  badge = icon.parentElement ? icon.parentElement.querySelector('.g03-s09-badge') : null;
  icon.classList.add('is-jump');
  await wait(260);
  icon.classList.remove('member_base_partner');
  icon.classList.add('member_base_self');
  icon.setAttribute('aria-label', '베이스사업자 본인');
  icon.innerHTML = '';
  if(badge){
    badge.classList.remove('is-hidden');
    badge.classList.add('is-in');
  }
  await wait(420);
  icon.classList.remove('is-jump');
}

function guide03Scene09Point(node, tree, yRatio){
  var icon = node && node.icon;
  var iconBox;
  var treeBox;
  var scale;
  if(!icon || !tree) return null;
  iconBox = icon.getBoundingClientRect();
  treeBox = tree.getBoundingClientRect();
  if(!iconBox.width || !treeBox.width) return null;
  scale = treeBox.width / (tree.offsetWidth || 1) || 1;
  return {
    x: (iconBox.left + iconBox.width / 2 - treeBox.left) / scale,
    y: (iconBox.top + iconBox.height * yRatio - treeBox.top) / scale
  };
}

function guide03Scene09Draw(assets, animate){
  var tree = assets && assets.tree;
  var svg = assets && assets.lines;
  var w;
  var h;
  if(!tree || !svg) return;
  w = tree.offsetWidth || 1;
  h = tree.offsetHeight || 1;
  svg.setAttribute('viewBox', '0 0 ' + w + ' ' + h);
  svg.setAttribute('width', String(w));
  svg.setAttribute('height', String(h));
  assets.links.forEach(function(link){
    var from;
    var to;
    var len;
    if(!link.on) return;
    from = guide03Scene09Point(link.from, tree, 0.92);
    to = guide03Scene09Point(link.to, tree, 0.12);
    if(!from || !to) return;
    link.path.setAttribute('d', 'M' + from.x + ' ' + from.y + ' L' + to.x + ' ' + to.y);
    if(!animate || link.drawn){
      link.path.style.strokeDashoffset = '0';
      link.drawn = true;
      return;
    }
    len = link.path.getTotalLength ? link.path.getTotalLength() : 0;
    link.path.style.transition = 'none';
    link.path.style.strokeDashoffset = String(len || 0);
    link.drawn = true;
  });
  svg.classList.add('is-on');
  if(!animate) return;
  window.requestAnimationFrame(function(){
    assets.links.forEach(function(link){
      if(!link.on) return;
      link.path.style.transition = 'stroke-dashoffset 720ms cubic-bezier(.16,1,.3,1)';
      link.path.style.strokeDashoffset = '0';
    });
  });
}

function guide03Scene09Track(assets, ms){
  var started = performance.now();
  if(assets._track) clearInterval(assets._track);
  assets._track = window.setInterval(function(){
    guide03Scene09Draw(assets, false);
    if(performance.now() - started < ms) return;
    clearInterval(assets._track);
    assets._track = null;
    guide03Scene09Draw(assets, false);
  }, 32);
}

function guide03Scene09ShowLinks(assets, pairs){
  var i;
  for(i = 0; i < pairs.length; i++) pairs[i].on = true;
  guide03Scene09Draw(assets, true);
}

async function runGuide03Scene09(tl, assets, ctx){
  var T = Guide03Scene09Config.T;
  var at = function(ms){ return guide03Scene09AtMain(ms, ctx); };

  await tl.wait(T.member);
  if(guide03Scene09Cancelled(ctx)) return;
  await guide03Scene09Reveal(assets, [assets.self]);

  await tl.wait(at(T.row2[0]));
  if(guide03Scene09Cancelled(ctx)) return;
  await guide03Scene09Reveal(assets, [assets.row2[0]]);

  await tl.wait(at(T.row2[1]));
  if(guide03Scene09Cancelled(ctx)) return;
  await guide03Scene09Reveal(assets, [assets.row2[1]]);

  await tl.wait(at(T.selfJump));
  if(guide03Scene09Cancelled(ctx)) return;
  guide03Scene09ShowLinks(assets, [assets.links[0], assets.links[1]]);
  await guide03Scene09JumpToSelf(assets.self.icon);

  await tl.wait(at(T.row3[0]));
  if(guide03Scene09Cancelled(ctx)) return;
  await guide03Scene09Reveal(assets, [assets.row3[0], assets.row3[1]]);

  await tl.wait(at(T.row3[1]));
  if(guide03Scene09Cancelled(ctx)) return;
  await guide03Scene09Reveal(assets, [assets.row3[2], assets.row3[3]]);

  await tl.wait(at(T.row2Jump));
  if(guide03Scene09Cancelled(ctx)) return;
  guide03Scene09ShowLinks(assets, assets.links.slice(2, 6));
  await Promise.all([
    guide03Scene09JumpToSelf(assets.row2[0].icon),
    guide03Scene09JumpToSelf(assets.row2[1].icon)
  ]);
  guide03Scene09Draw(assets, false);

  await tl.wait(at(T.row4[0]));
  if(guide03Scene09Cancelled(ctx)) return;
  await guide03Scene09Reveal(assets, [assets.row4[0], assets.row4[1]]);

  await tl.wait(at(T.row4[1]));
  if(guide03Scene09Cancelled(ctx)) return;
  await guide03Scene09Reveal(assets, [assets.row4[2], assets.row4[3]]);

  await tl.wait(at(T.row3Jump));
  if(guide03Scene09Cancelled(ctx)) return;
  guide03Scene09ShowLinks(assets, assets.links.slice(6));
  await Promise.all([
    guide03Scene09JumpToSelf(assets.row3[0].icon),
    guide03Scene09JumpToSelf(assets.row3[2].icon)
  ]);

  await tl.wait(at(T.arrow));
  if(guide03Scene09Cancelled(ctx)) return;
  assets.arrow.classList.add('is-up');
  if(typeof Guide03Scene09Layout !== 'undefined') Guide03Scene09Layout.schedule();
}
</script>
