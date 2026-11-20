<script>
var Guide04Scene01 = defineScene({
  id: Guide04Scene01Config.id,
  title: Guide04Scene01Config.title,
  duration: Guide04Scene01Config.duration,
  mediaSequence: Guide04Scene01Config.media.sequence,
  mediaFallbackMs: Guide04Scene01Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide04Scene01Config.panelCls);
    if(typeof Guide04Scene01Layout !== 'undefined') Guide04Scene01Layout.unbind();
    Guide04.resetScene(Guide04Scene01Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide04Scene01Config.panelCls);
    tl = Guide04.timeline(ctx);
    Guide04.resetScene(Guide04Scene01Config.canvasCls);
    Guide04.mountStage(canvas, Guide04Scene01Config.canvasCls);
    assets = setupGuide04Scene01(canvas);

    await Promise.all([
      runGuide04Scene01(tl, assets, ctx),
      Guide04.panelBulletTimeline(
        tl,
        Guide04Scene01Config.panel.title,
        Guide04Scene01Config.panel.bullets,
        guide04Scene01PanelFlashes(ctx)
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide04.finishSceneHold(tl, ctx.sceneDuration || Guide04Scene01Config.duration);
  }
});

function guide04Scene01Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function guide04Scene01Reveal(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g04-enter');
  if(typeof Guide04Scene01Layout !== 'undefined') Guide04Scene01Layout.schedule();
  await wait(760);
  el.classList.remove('g04-enter');
}

async function guide04Scene01Open(slot){
  if(!slot) return;
  var done = guide04EaseOpen(slot);
  if(typeof Guide04Scene01Layout !== 'undefined') Guide04Scene01Layout.schedule();
  await done;
}

async function guide04Scene01UnfoldChip(wrap){
  var badge;
  var text;
  var track;
  var gap;
  var textW;
  if(!wrap) return;
  badge = wrap.querySelector('.recommend_bonus_icon_o, .base_business_icon_o, .autoship_icon_o');
  text = badge && badge.querySelector('.recommend_bonus_text, .base_text, .autoship_text');
  if(!badge || !text){
    await guide04Scene01Reveal(wrap);
    return;
  }
  showElement(wrap);
  badge.classList.add('g04-fold');
  gap = parseFloat(getComputedStyle(badge).getPropertyValue('--size')) * 5 / 36;
  if(!gap || gap < 1) gap = 6;
  badge.style.setProperty('--g04-gap', gap + 'px');
  textW = Math.ceil(text.scrollWidth || text.getBoundingClientRect().width);
  track = document.createElement('span');
  track.className = 'g04-fold-track';
  text.parentNode.insertBefore(track, text);
  track.appendChild(text);
  track.style.maxWidth = '0px';
  text.style.opacity = '0';
  if(typeof Guide04Scene01Layout !== 'undefined') Guide04Scene01Layout.schedule();
  await wait(40);
  track.style.transition = 'max-width 640ms cubic-bezier(.22,1,.36,1)';
  text.style.transition = 'opacity 360ms cubic-bezier(.25,.1,.25,1) 120ms';
  track.style.maxWidth = (textW + gap) + 'px';
  text.style.opacity = '1';
  await wait(700);
}

async function guide04Scene01FoldAway(wrap){
  var badge;
  var track;
  var text;
  if(!wrap) return;
  badge = wrap.querySelector('.recommend_bonus_icon_o, .base_business_icon_o');
  track = wrap.querySelector('.g04-fold-track');
  text = track && track.firstElementChild;
  if(badge && track && text){
    track.style.transition = 'max-width 420ms cubic-bezier(.22,1,.36,1)';
    text.style.transition = 'opacity 220ms ease';
    text.style.opacity = '0';
    track.style.maxWidth = '0px';
    await wait(440);
  }
  wrap.classList.add('is-hidden');
  if(typeof Guide04Scene01Layout !== 'undefined') Guide04Scene01Layout.schedule();
}

function guide04Scene01Point(icon, tree, yRatio){
  var iconBox = icon.getBoundingClientRect();
  var treeBox = tree.getBoundingClientRect();
  var scale = treeBox.width / (tree.offsetWidth || 1) || 1;
  return {
    x: (iconBox.left + iconBox.width / 2 - treeBox.left) / scale,
    y: (iconBox.top + iconBox.height * yRatio - treeBox.top) / scale
  };
}

function guide04Scene01DrawLines(assets, animate){
  var tree = assets.tree;
  var svg = assets.lines;
  var selfIcon = assets.self.icon;
  var leftIcon = assets.left.icon;
  var rightIcon = assets.right.icon;
  if(!tree || !svg || !selfIcon || !leftIcon || !rightIcon) return;
  var from = guide04Scene01Point(selfIcon, tree, 0.94);
  var left = guide04Scene01Point(leftIcon, tree, 0.18);
  var right = guide04Scene01Point(rightIcon, tree, 0.18);
  var w = tree.offsetWidth || 1;
  var h = tree.offsetHeight || 1;
  svg.setAttribute('viewBox', '0 0 ' + w + ' ' + h);
  svg.setAttribute('width', String(w));
  svg.setAttribute('height', String(h));
  var paths = svg.querySelectorAll('path');
  [[left, paths[0]], [right, paths[1]]].forEach(function(pair){
    var to = pair[0];
    var path = pair[1];
    if(!path) return;
    path.setAttribute('d', 'M' + from.x + ' ' + from.y + ' L' + to.x + ' ' + to.y);
    if(!animate){
      path.style.strokeDashoffset = '0';
      return;
    }
    var len = path.getTotalLength ? path.getTotalLength() : 0;
    path.style.transition = 'none';
    path.style.strokeDashoffset = String(len || 0);
  });
  svg.classList.add('is-on');
  if(!animate) return;
  window.requestAnimationFrame(function(){
    paths.forEach(function(path){
      path.style.transition = 'stroke-dashoffset 720ms cubic-bezier(.16,1,.3,1)';
      path.style.strokeDashoffset = '0';
    });
  });
}

async function guide04Scene01FlyCoin(fromEl, toEl, stage){
  var from;
  var to;
  var coin;
  var dx;
  var dy;
  if(!fromEl || !toEl || !stage) return;
  from = fromEl.getBoundingClientRect();
  to = toEl.getBoundingClientRect();
  coin = document.createElement('div');
  coin.className = 'g04-point-coin';
  coin.textContent = 'P';
  stage.appendChild(coin);
  coin.style.left = (from.left + from.width / 2 - stage.getBoundingClientRect().left) + 'px';
  coin.style.top = (from.top + from.height / 2 - stage.getBoundingClientRect().top) + 'px';
  dx = (to.left + to.width / 2) - (from.left + from.width / 2);
  dy = (to.top + to.height / 2) - (from.top + from.height / 2);
  await wait(30);
  coin.style.transform = 'translate(' + dx + 'px,' + dy + 'px) scale(.72)';
  coin.style.opacity = '0.15';
  await wait(680);
  if(coin.parentNode) coin.parentNode.removeChild(coin);
}

async function guide04Scene01UnfoldBaseOntoSelf(assets){
  var temp = document.createElement('div');
  var badge = Guide04.cloneTemplate('base_business_icon');
  if(!badge || !assets.baseDock) return;
  temp.className = 'g04-slot g04-base-fly';
  temp.appendChild(badge);
  assets.stage.appendChild(temp);
  showElement(temp);
  await guide04Scene01UnfoldChip(temp);
  await wait(420);
  await guide04Scene01FoldAway(temp);
  if(temp.parentNode) temp.parentNode.removeChild(temp);
  showElement(assets.baseDock);
  assets.baseDock.classList.add('g04-fade');
  if(typeof Guide04Scene01Layout !== 'undefined') Guide04Scene01Layout.schedule();
  await wait(760);
  assets.baseDock.classList.remove('g04-fade');
}

async function runGuide04Scene01(tl, assets, ctx){
  var T = Guide04Scene01Config.T;
  var at = function(ms){ return guide04Scene01AtMain(ms, ctx); };
  var i;

  await tl.wait(T.badge);
  if(guide04Scene01Cancelled(ctx)) return;
  await guide04Scene01UnfoldChip(assets.badge);

  await tl.wait(at(T.board));
  if(guide04Scene01Cancelled(ctx)) return;
  await guide04Scene01FoldAway(assets.badge);
  await guide04Scene01Reveal(assets.board);

  await tl.wait(at(T.self));
  if(guide04Scene01Cancelled(ctx)) return;
  await guide04Scene01Open(assets.self.slot);

  for(i = 0; i < T.partners.length; i++){
    await tl.wait(at(T.partners[i]));
    if(guide04Scene01Cancelled(ctx)) return;
    await guide04Scene01Open(i === 0 ? assets.left.slot : assets.right.slot);
  }
  if(guide04Scene01Cancelled(ctx)) return;
  guide04Scene01DrawLines(assets, true);

  await tl.wait(at(T.products));
  if(guide04Scene01Cancelled(ctx)) return;
  showElement(assets.auto.querySelector('.g04-product'));
  showElement(assets.pack.querySelector('.g04-product'));
  await Promise.all([
    guide04Scene01Open(assets.auto),
    guide04Scene01Open(assets.pack)
  ]);

  await tl.wait(at(T.coins));
  if(guide04Scene01Cancelled(ctx)) return;
  showElement(assets.recommendDock);
  assets.recommendDock.classList.add('g04-fade');
  if(typeof Guide04Scene01Layout !== 'undefined') Guide04Scene01Layout.schedule();
  await Promise.all([
    guide04Scene01FlyCoin(assets.auto, assets.recommendDock, assets.stage),
    wait(180).then(function(){
      return guide04Scene01FlyCoin(assets.pack, assets.recommendDock, assets.stage);
    })
  ]);
  assets.recommendDock.classList.remove('g04-fade');

  await tl.wait(at(T.right));
  if(guide04Scene01Cancelled(ctx)) return;
  await guide04Scene01Open(assets.rightChip);

  await tl.wait(at(T.deny));
  if(guide04Scene01Cancelled(ctx)) return;
  assets.board.classList.add('is-muted');
  showElement(assets.deny);
  assets.deny.classList.add('g04-enter');
  await wait(900);
  assets.deny.classList.remove('g04-enter');
  assets.deny.classList.add('is-hidden');
  assets.board.classList.remove('is-muted');

  await tl.wait(at(T.base));
  if(guide04Scene01Cancelled(ctx)) return;
  if(assets.recommendDock) assets.recommendDock.classList.add('is-hidden');
  await guide04Scene01UnfoldBaseOntoSelf(assets);

  for(i = 0; i < T.summary.length; i++){
    await tl.wait(at(T.summary[i]));
    if(guide04Scene01Cancelled(ctx)) return;
    await guide04Scene01Reveal(assets.summary[i]);
  }
}
</script>
