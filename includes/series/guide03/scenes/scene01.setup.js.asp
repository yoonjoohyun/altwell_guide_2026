<script>
var Guide03Scene01Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    var canvas = _ctx && _ctx.canvas;
    var inner = _ctx && _ctx.inner;
    var stage = _ctx && _ctx.stage;
    var fit = 1;
    if(!canvas || !inner || !stage) return;
    var w = stage.offsetWidth || 1;
    var h = stage.offsetHeight || 1;
    fit = Math.min(1, (canvas.clientWidth - 16) / w, (canvas.clientHeight - 16) / h);
    if(fit < 0.42) fit = 0.42;
    inner.style.setProperty('--group-scale', String(Math.round(fit * 1000) / 1000));
  }

  function schedule(){
    requestAnimationFrame(applyFit);
  }

  function bind(ctx){
    _ctx = ctx;
    if(_resizeBound) return;
    _resizeBound = true;
    window.addEventListener('resize', schedule);
  }

  function unbind(){
    _resizeBound = false;
    _ctx = null;
  }

  return { schedule: schedule, bind: bind, unbind: unbind };
})();

function setupGuide03Scene01(canvas){
  var zone = Guide03Scene01Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var board = document.createElement('div');
  var tree = document.createElement('div');
  var lines = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  var rowTop = document.createElement('div');
  var rowBottom = document.createElement('div');

  function grow(child){
    var slot = document.createElement('div');
    var clip = document.createElement('div');
    slot.className = 'g03-grow';
    clip.className = 'g03-grow-clip';
    clip.appendChild(child);
    slot.appendChild(clip);
    return slot;
  }

  function memberSlot(id){
    var icon = Guide03.cloneTemplate('member_icon');
    var wrap = document.createElement('div');
    wrap.className = 'g03-member';
    if(icon){
      icon.id = id;
      wrap.appendChild(icon);
    }
    return { slot: grow(wrap), icon: icon };
  }

  stack.id = 'g03-s01-stack';
  stack.className = 'g03-stack lo-zone-place';
  Guide03.placeAtZone(stack, zone);
  inner.className = 'g03-stack-inner';
  stage.className = 'g03-s01';
  board.id = 'g03-s01-board';
  board.className = 'g03-board g03-slot is-hidden';
  tree.className = 'g03-tree';
  lines.setAttribute('class', 'g03-lines');
  lines.setAttribute('aria-hidden', 'true');
  [0, 1].forEach(function(){
    var path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    path.setAttribute('fill', 'none');
    lines.appendChild(path);
  });
  rowTop.className = 'g03-member-row';
  rowBottom.className = 'g03-member-row';

  var badge = Guide03.cloneTemplate('base_business_icon');
  var badgeWrap = document.createElement('div');
  badgeWrap.id = 'g03-s01-badge';
  badgeWrap.className = 'g03-slot g03-base-badge is-hidden';
  if(badge) badgeWrap.appendChild(badge);

  var top = memberSlot('g03-s01-member-self');
  var left = memberSlot('g03-s01-member-left');
  var right = memberSlot('g03-s01-member-right');
  rowTop.appendChild(top.slot);
  rowBottom.appendChild(left.slot);
  rowBottom.appendChild(right.slot);

  var unit = document.createElement('div');
  unit.className = 'g03-unit-label';
  unit.textContent = '앨트웰 비즈니스 기본 단위';
  var unitSlot = grow(unit);

  var bonus = Guide03.cloneTemplate('recommend_bonus_icon');
  var bonusWrap = document.createElement('div');
  bonusWrap.id = 'g03-s01-bonus';
  bonusWrap.className = 'g03-slot g03-chip is-hidden';
  if(bonus){
    var bonusText = bonus.querySelector('.recommend_bonus_text');
    if(bonusText) bonusText.textContent = '각종 보너스 수혜 기준';
    bonus.setAttribute('aria-label', '각종 보너스 수혜 기준');
    bonusWrap.appendChild(bonus);
  }

  var rank = Guide03.cloneTemplate('guide_info_badge_red');
  var rankWrap = document.createElement('div');
  rankWrap.id = 'g03-s01-rank';
  rankWrap.className = 'g03-slot g03-chip is-hidden';
  if(rank){
    var rankText = rank.querySelector('.guide_info_badge_text');
    if(rankText) rankText.textContent = '승급 기준에 활용';
    rank.setAttribute('aria-label', '승급 기준에 활용');
    rankWrap.appendChild(rank);
  }

  tree.appendChild(lines);
  tree.appendChild(rowTop);
  tree.appendChild(rowBottom);
  board.appendChild(tree);
  board.appendChild(unitSlot);
  stage.appendChild(badgeWrap);
  stage.appendChild(board);
  stage.appendChild(bonusWrap);
  stage.appendChild(rankWrap);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide03Scene01Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide03Scene01Layout.schedule();

  return {
    inner: inner,
    stage: stage,
    badge: badgeWrap,
    board: board,
    tree: tree,
    lines: lines,
    members: [top, left, right],
    unit: unitSlot,
    bonus: bonusWrap,
    rank: rankWrap
  };
}
</script>
