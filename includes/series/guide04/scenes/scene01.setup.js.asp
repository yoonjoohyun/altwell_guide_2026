<script>
var Guide04Scene01Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    if(!_ctx || typeof Guide04 === 'undefined') return;
    Guide04.fitGroup(_ctx.canvas, _ctx.inner, _ctx.stage, _ctx.badge);
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

function setupGuide04Scene01(canvas){
  var zone = Guide04Scene01Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var board = document.createElement('div');
  var tree = document.createElement('div');
  var lines = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  var rowTop = document.createElement('div');
  var rowBottom = document.createElement('div');
  var colLeft = document.createElement('div');
  var colRight = document.createElement('div');
  var summary = document.createElement('div');
  var denyLayer = document.createElement('div');

  function grow(child){
    var slot = document.createElement('div');
    var clip = document.createElement('div');
    slot.className = 'g04-grow';
    clip.className = 'g04-grow-clip';
    clip.appendChild(child);
    slot.appendChild(clip);
    return slot;
  }

  function memberSlot(id, label){
    var icon = Guide04.cloneTemplate('member_icon');
    var wrap = document.createElement('div');
    wrap.className = 'g04-member';
    if(icon){
      icon.id = id;
      if(label){
        icon.innerHTML = '<span class="member_face_label">' + label + '</span>';
        icon.setAttribute('aria-label', label);
      }
      wrap.appendChild(icon);
    }
    return { slot: grow(wrap), wrap: wrap, icon: icon };
  }

  function attachDock(hostWrap, id, templateId, folded){
    var dock;
    var badgeWrap;
    var badge;
    if(!hostWrap) return null;
    dock = document.createElement('div');
    dock.className = 'g04-s01-dock';
    badgeWrap = document.createElement('div');
    badgeWrap.id = id;
    badgeWrap.className = 'g04-slot g04-s01-dock-badge is-hidden';
    badge = Guide04.cloneTemplate(templateId);
    if(badge){
      if(folded){
        badge.classList.remove('base_business_icon_o', 'recommend_bonus_icon_o');
        badge.classList.add(templateId === 'base_business_icon' ? 'base_business_icon_c' : 'recommend_bonus_icon_c');
      }
      badgeWrap.appendChild(badge);
    }
    dock.appendChild(badgeWrap);
    hostWrap.appendChild(dock);
    return badgeWrap;
  }

  stack.id = 'g04-s01-stack';
  stack.className = 'g04-stack g01-zone-wrap lo-zone-place';
  Guide04.placeAtZone(stack, zone);
  inner.className = 'g04-stack-inner';
  stage.className = 'g04-s01';
  board.id = 'g04-s01-board';
  board.className = 'g04-board g04-slot is-hidden';
  tree.className = 'g04-tree';
  lines.setAttribute('class', 'g04-lines');
  lines.setAttribute('aria-hidden', 'true');
  [0, 1].forEach(function(){
    var path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    path.setAttribute('fill', 'none');
    lines.appendChild(path);
  });
  rowTop.className = 'g04-member-row';
  rowBottom.className = 'g04-member-row g04-partner-row';
  colLeft.className = 'g04-partner-col';
  colRight.className = 'g04-partner-col';

  var badge = Guide04.cloneTemplate('recommend_bonus_icon');
  var badgeWrap = document.createElement('div');
  badgeWrap.id = 'g04-s01-badge';
  badgeWrap.className = 'g04-slot g04-bonus-badge is-hidden';
  if(badge) badgeWrap.appendChild(badge);

  var self = memberSlot('g04-s01-self', '본인');
  self.wrap.classList.add('g04-s01-self-host');
  if(self.icon){
    self.icon.classList.add('member_base_self');
    self.icon.setAttribute('aria-label', '베이스사업자 본인');
  }
  var recommendDock = attachDock(self.wrap, 'g04-s01-recommend-dock', 'recommend_bonus_icon', true);
  var baseDock = attachDock(self.wrap, 'g04-s01-base-dock', 'base_business_icon', true);

  var left = memberSlot('g04-s01-left', '추천');
  var right = memberSlot('g04-s01-right', '추천');

  var auto = Guide04.cloneTemplate('autoship_icon');
  var autoWrap = document.createElement('div');
  autoWrap.className = 'g04-slot g04-product is-hidden';
  if(auto){
    var autoText = auto.querySelector('.autoship_text');
    if(autoText) autoText.textContent = '오토십 구독';
    autoWrap.appendChild(auto);
  }
  var autoSlot = grow(autoWrap);

  var pack = Guide04.cloneTemplate('startpack_badge');
  var packWrap = document.createElement('div');
  packWrap.className = 'g04-slot g04-product g04-startpack is-hidden';
  if(pack) packWrap.appendChild(pack);
  var packSlot = grow(packWrap);

  colLeft.appendChild(left.slot);
  colLeft.appendChild(autoSlot);
  colRight.appendChild(right.slot);
  colRight.appendChild(packSlot);
  rowTop.appendChild(self.slot);
  rowBottom.appendChild(colLeft);
  rowBottom.appendChild(colRight);

  var rightChip = document.createElement('div');
  rightChip.className = 'g04-chip-text';
  rightChip.textContent = '권리소득';
  var rightSlot = grow(rightChip);
  rightSlot.classList.add('g04-right-chip');

  summary.className = 'g04-summary';
  var summaryLines = [
    'BASE 유지',
    '신규 회원 추천',
    '제품 이용 지원'
  ].map(function(text, i){
    var line = document.createElement('div');
    line.className = 'g04-summary-line g04-slot is-hidden';
    line.id = 'g04-s01-sum-' + i;
    line.textContent = text;
    summary.appendChild(line);
    return line;
  });

  denyLayer.className = 'g04-deny is-hidden';
  denyLayer.setAttribute('aria-hidden', 'true');
  var cross = Guide04.cloneTemplate('status_cross_icon');
  if(cross) denyLayer.appendChild(cross);

  tree.appendChild(lines);
  tree.appendChild(rowTop);
  tree.appendChild(rowBottom);
  board.appendChild(tree);
  board.appendChild(rightSlot);
  board.appendChild(summary);
  board.appendChild(denyLayer);

  stage.appendChild(badgeWrap);
  stage.appendChild(board);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide04Scene01Layout.bind({ canvas: canvas, inner: inner, stage: stage, badge: badgeWrap });
  Guide04Scene01Layout.schedule();

  return {
    inner: inner,
    stage: stage,
    badge: badgeWrap,
    board: board,
    tree: tree,
    lines: lines,
    self: self,
    left: left,
    right: right,
    auto: autoSlot,
    pack: packSlot,
    recommendDock: recommendDock,
    baseDock: baseDock,
    rightChip: rightSlot,
    summary: summaryLines,
    deny: denyLayer
  };
}
</script>
