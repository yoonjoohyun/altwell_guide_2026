<script>
var Guide03Scene01 = defineScene({
  id: Guide03Scene01Config.id,
  title: Guide03Scene01Config.title,
  duration: Guide03Scene01Config.duration,
  mediaSequence: Guide03Scene01Config.media.sequence,
  mediaFallbackMs: Guide03Scene01Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide03Scene01Config.panelCls);
    if(typeof Guide03Scene01Layout !== 'undefined') Guide03Scene01Layout.unbind();
    Guide03.resetScene(Guide03Scene01Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide03Scene01Config.panelCls);
    tl = Guide03.timeline(ctx);
    Guide03.resetScene(Guide03Scene01Config.canvasCls);
    Guide03.mountStage(canvas, Guide03Scene01Config.canvasCls);
    assets = setupGuide03Scene01(canvas);

    await Promise.all([
      runGuide03Scene01(tl, assets, ctx),
      Guide03.panelBulletTimeline(
        tl,
        Guide03Scene01Config.panel.title,
        Guide03Scene01Config.panel.bullets,
        guide03Scene01PanelFlashes(ctx)
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide03.finishSceneHold(tl, ctx.sceneDuration || Guide03Scene01Config.duration);
  }
});

function guide03Scene01Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function guide03Scene01Reveal(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g03-enter');
  if(typeof Guide03Scene01Layout !== 'undefined') Guide03Scene01Layout.schedule();
  await wait(760);
  el.classList.remove('g03-enter');
}

async function guide03Scene01Open(slot){
  if(!slot) return;
  slot.classList.add('is-open');
  if(typeof Guide03Scene01Layout !== 'undefined') Guide03Scene01Layout.schedule();
  await wait(740);
}

async function guide03Scene01JumpTo(icon, kind){
  var label;
  if(!icon) return;
  icon.classList.add('is-jump');
  await wait(260);
  if(kind === 'self'){
    icon.classList.add('member_base_self');
    icon.setAttribute('aria-label', '베이스사업자 본인');
    label = '본인';
  }else{
    icon.classList.add('member_base_partner');
    icon.setAttribute('aria-label', '베이스사업자 파트너');
    label = '파트너';
  }
  icon.innerHTML = '<span class="member_face_label">' + label + '</span>';
  await wait(420);
  icon.classList.remove('is-jump');
}

async function runGuide03Scene01(tl, assets, ctx){
  var T = Guide03Scene01Config.T;
  var at = function(ms){ return guide03Scene01AtMain(ms, ctx); };
  var i;

  await tl.wait(T.badge);
  if(guide03Scene01Cancelled(ctx)) return;
  await guide03Scene01UnfoldChip(assets.badge);

  await tl.wait(at(T.board));
  if(guide03Scene01Cancelled(ctx)) return;
  await guide03Scene01Reveal(assets.board);

  for(i = 0; i < assets.members.length; i++){
    await tl.wait(at(T.members[i]));
    if(guide03Scene01Cancelled(ctx)) return;
    await guide03Scene01Open(assets.members[i].slot);
  }

  await tl.wait(at(T.self));
  if(guide03Scene01Cancelled(ctx)) return;
  await guide03Scene01JumpTo(assets.members[0].icon, 'self');

  await tl.wait(at(T.partners));
  if(guide03Scene01Cancelled(ctx)) return;
  await Promise.all([
    guide03Scene01JumpTo(assets.members[1].icon, 'partner'),
    guide03Scene01JumpTo(assets.members[2].icon, 'partner')
  ]);
  if(guide03Scene01Cancelled(ctx)) return;
  guide03Scene01DrawLines(assets, true);

  await tl.wait(at(T.unit));
  if(guide03Scene01Cancelled(ctx)) return;
  await guide03Scene01Open(assets.unit);

  await tl.wait(at(T.bonus));
  if(guide03Scene01Cancelled(ctx)) return;
  await guide03Scene01UnfoldChip(assets.bonus);

  await tl.wait(at(T.rank));
  if(guide03Scene01Cancelled(ctx)) return;
  await guide03Scene01UnfoldChip(assets.rank);
}

function guide03Scene01Point(icon, tree, yRatio){
  var iconBox = icon.getBoundingClientRect();
  var treeBox = tree.getBoundingClientRect();
  var scale = treeBox.width / (tree.offsetWidth || 1) || 1;
  return {
    x: (iconBox.left + iconBox.width / 2 - treeBox.left) / scale,
    y: (iconBox.top + iconBox.height * yRatio - treeBox.top) / scale
  };
}

function guide03Scene01DrawLines(assets, animate){
  var tree = assets.tree;
  var svg = assets.lines;
  var selfIcon = assets.members[0].icon;
  var leftIcon = assets.members[1].icon;
  var rightIcon = assets.members[2].icon;
  if(!tree || !svg || !selfIcon || !leftIcon || !rightIcon) return;
  var from = guide03Scene01Point(selfIcon, tree, 0.94);
  var left = guide03Scene01Point(leftIcon, tree, 0.18);
  var right = guide03Scene01Point(rightIcon, tree, 0.18);
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

async function guide03Scene01UnfoldChip(wrap){
  var badge;
  var text;
  var track;
  var gap;
  var textW;
  if(!wrap) return;
  badge = wrap.querySelector('.base_business_icon_o, .recommend_bonus_icon_o, .guide_info_badge');
  text = badge && badge.querySelector('.base_text, .recommend_bonus_text, .guide_info_badge_text');
  if(!badge || !text){
    await guide03Scene01Reveal(wrap);
    return;
  }
  showElement(wrap);
  badge.classList.add('g03-fold');
  gap = parseFloat(getComputedStyle(badge).getPropertyValue('--size')) * 5 / 36;
  if(!gap || gap < 1) gap = 6;
  badge.style.setProperty('--g03-gap', gap + 'px');
  textW = Math.ceil(text.scrollWidth || text.getBoundingClientRect().width);
  track = document.createElement('span');
  track.className = 'g03-fold-track';
  text.parentNode.insertBefore(track, text);
  track.appendChild(text);
  track.style.maxWidth = '0px';
  text.style.opacity = '0';
  if(typeof Guide03Scene01Layout !== 'undefined') Guide03Scene01Layout.schedule();
  await wait(40);
  track.style.transition = 'max-width 640ms cubic-bezier(.22,1,.36,1)';
  text.style.transition = 'opacity 360ms cubic-bezier(.25,.1,.25,1) 120ms';
  track.style.maxWidth = (textW + gap) + 'px';
  text.style.opacity = '1';
  await wait(700);
}
</script>
