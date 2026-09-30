<script>
var Guide02Scene07 = defineScene({
  id: Guide02Scene07Config.id,
  title: Guide02Scene07Config.title,
  duration: Guide02Scene07Config.duration,
  mediaSequence: Guide02Scene07Config.media.sequence,
  mediaFallbackMs: Guide02Scene07Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide02Scene07Config.panelCls);
    if(typeof Guide02Scene07Layout !== 'undefined') Guide02Scene07Layout.unbind();
    Guide02.resetScene(Guide02Scene07Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide02Scene07Config.panelCls);
    tl = Guide02.timeline(ctx);
    Guide02.resetScene(Guide02Scene07Config.canvasCls);
    Guide02.mountStage(canvas, Guide02Scene07Config.canvasCls);
    assets = setupGuide02Scene07(canvas);

    await Promise.all([
      runGuide02Scene07(tl, assets, ctx),
      Guide02.panelBulletTimeline(
        tl,
        Guide02Scene07Config.panel.title,
        Guide02Scene07Config.panel.bullets,
        guide02Scene07PanelFlashes(ctx)
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide02.finishSceneHold(tl, ctx.sceneDuration || Guide02Scene07Config.duration);
  }
});

function guide02Scene07Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function guide02Scene07Reveal(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g02-enter');
  if(typeof Guide02Scene07Layout !== 'undefined') Guide02Scene07Layout.schedule();
  await wait(420);
  el.classList.remove('g02-enter');
  el.classList.add('g02-idle');
}

async function guide02Scene07FoldAway(assets){
  var badge = assets.badgeRoot;
  var wrap = assets.badge;
  var name = badge && badge.querySelector('.g02_startpack_name');
  var row = badge && badge.querySelector('.g02_startpack_row');
  if(!badge || !wrap || !name || !row) return;

  wrap.classList.remove('g02-idle', 'g02-enter');
  var nameW = Math.ceil(name.getBoundingClientRect().width);
  var gap = 8;
  var track = document.createElement('span');
  track.className = 'g02-s07-name-track';
  row.insertBefore(track, name);
  track.appendChild(name);
  row.style.gap = '0px';
  name.style.marginLeft = gap + 'px';
  track.style.maxWidth = (nameW + gap) + 'px';
  await wait(32);
  if(!wrap.isConnected) return;

  var widthDur = 536;
  var textDur = 208;
  track.style.transition = 'max-width ' + widthDur + 'ms cubic-bezier(.22,1,.36,1)';
  track.style.maxWidth = '0px';
  await wait(widthDur);
  if(!wrap.isConnected) return;

  name.style.transition = 'opacity ' + textDur + 'ms cubic-bezier(.25,.1,.25,1)';
  name.style.opacity = '0';
  await wait(textDur);
  if(!wrap.isConnected) return;

  wrap.classList.add('is-leaving');
  await wait(420);
  if(!wrap.isConnected) return;
  wrap.classList.remove('is-leaving');
  wrap.classList.add('is-hidden');
  if(typeof Guide02Scene07Layout !== 'undefined') Guide02Scene07Layout.schedule();
}

async function guide02Scene07RevealStill(el){
  if(!el) return;
  showElement(el);
  el.classList.remove('g02-idle');
  el.classList.add('g02-enter');
  if(typeof Guide02Scene07Layout !== 'undefined') Guide02Scene07Layout.schedule();
  await wait(420);
  el.classList.remove('g02-enter');
}

async function guide02Scene07BenefitToPlus(el, ctx){
  if(!el) return;
  await guide02Scene07RevealStill(el);
  await wait(1500);
  if(!el.isConnected || guide02Scene07Cancelled(ctx)) return;
  el.style.width = el.offsetWidth + 'px';
  void el.offsetWidth;
  el.classList.add('is-spin', 'is-plus');
  el.style.width = '72px';
  await wait(320);
  if(!el.isConnected || guide02Scene07Cancelled(ctx)) return;
  el.textContent = '!';
  await wait(520);
  if(!el.isConnected || guide02Scene07Cancelled(ctx)) return;
  el.classList.remove('is-spin');
  await wait(200);
  if(!el.isConnected || guide02Scene07Cancelled(ctx)) return;
  el.style.transition = 'none';
  await new Promise(function(resolve){
    var t0 = performance.now();
    var dur = 680;
    var timer = setInterval(function(){
      if(!el.isConnected){ clearInterval(timer); resolve(); return; }
      var p = Math.min(1, (performance.now() - t0) / dur);
      var e = p < 0.5 ? 2 * p * p : 1 - Math.pow(-2 * p + 2, 2) / 2;
      el.style.opacity = String(1 - e);
      if(p >= 1){ clearInterval(timer); resolve(); }
    }, 32);
  });
  if(!el.isConnected) return;
  el.classList.add('is-gone', 'is-hidden');
  if(typeof Guide02Scene07Layout !== 'undefined') Guide02Scene07Layout.schedule();
}

async function guide02Scene07RevealOrbPart(el){
  if(!el) return;
  showElement(el);
  el.classList.remove('g02-idle', 'g02-enter');
  el.classList.add('g02-s07-float');
  if(typeof Guide02Scene07Layout !== 'undefined') Guide02Scene07Layout.schedule();
  await wait(680);
  el.classList.remove('g02-s07-float');
}

function guide02Scene07EaseRow(row, mutate){
  var nodes = Array.prototype.slice.call(row.children);
  var before = nodes.map(function(n){
    var box = n.getBoundingClientRect();
    return { hidden: n.classList.contains('is-hidden'), left: box.left, top: box.top };
  });
  mutate();
  if(typeof Guide02Scene07Layout !== 'undefined') Guide02Scene07Layout.flush();
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
    });
  });
}

async function guide02Scene07RevealOrb(orb){
  if(!orb) return;
  showElement(orb.wrap);
  orb.wrap.classList.add('g02-idle');
  await guide02Scene07RevealOrbPart(orb.face);
  await guide02Scene07RevealOrbPart(orb.text);
}

async function runGuide02Scene07(tl, assets, ctx){
  var T = Guide02Scene07Config.T;
  var at = function(ms){ return guide02Scene07AtMain(ms, ctx); };
  var i;

  await tl.wait(T.badge);
  if(guide02Scene07Cancelled(ctx)) return;
  await guide02Scene07Reveal(assets.badge);

  await tl.wait(at(T.fold));
  if(guide02Scene07Cancelled(ctx)) return;
  await guide02Scene07FoldAway(assets);
  if(guide02Scene07Cancelled(ctx)) return;

  await tl.wait(at(T.benefit));
  if(guide02Scene07Cancelled(ctx)) return;
  var benefitJob = guide02Scene07BenefitToPlus(assets.benefit, ctx);

  for(i = 0; i < assets.orbs.length; i++){
    await tl.wait(at(T.orbs[i]));
    if(guide02Scene07Cancelled(ctx)) return;
    if(i > 0){
      guide02Scene07EaseRow(assets.orbs[i - 1].wrap.parentNode, function(){
        assets.orbs[i - 1].wrap.classList.remove('g02-idle');
        assets.orbs[i - 1].face.classList.add('is-invert');
        if(assets.lines[i - 1]) showElement(assets.lines[i - 1]);
        showElement(assets.orbs[i].wrap);
      });
      if(assets.lines[i - 1]){
        await Promise.all([
          guide02Scene07RevealStill(assets.lines[i - 1]),
          guide02Scene07RevealOrb(assets.orbs[i])
        ]);
      }
    }else{
      await guide02Scene07RevealOrb(assets.orbs[i]);
    }
  }
  await benefitJob;
}
</script>
